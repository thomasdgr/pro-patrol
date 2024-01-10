extends Node

signal dialog_state


var level_name = ""
var points = 0
var npc_manager = preload("res://scripts/npc_manager.gd")
var dialogBox : Node
var level_id = -1
var level_cleared = false
var timer : SceneTreeTimer 
var events = []
const lvl_file = "res://lvl.txt"
var present_id = null

static var map_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_scenario_list():
	var curr_lvl = get_current_level()
	var lvl_list = []
	const lvl_path = "res://scenarios"
	var scenario_dir = DirAccess.open(lvl_path)
	if scenario_dir:
		scenario_dir.list_dir_begin()
		var file_name = scenario_dir.get_next()
		while file_name != "":
			if not scenario_dir.current_is_dir():
				# This is scenario_{id}.xml
				# Remove the first 9 chars
				# And the last 4 chars
				var scenario_id = file_name.get_slice("_", 1).get_slice(".", 0)
				var lvl = [scenario_id, int(scenario_id) <= curr_lvl]
				lvl_list.append(lvl)
			file_name = scenario_dir.get_next()
	return lvl_list
	
	
func get_current_level():
	var curr_lvl = 1
	# If there is not lvl.txt file, then create it with level set as 1
	if not FileAccess.file_exists(lvl_file):
		var file = FileAccess.open("res://lvl.txt", FileAccess.WRITE)
		file.store_string(str(curr_lvl))
	else:
		var file = FileAccess.open(lvl_file, FileAccess.READ)
		curr_lvl = int(file.get_as_text())
		if curr_lvl == 0:
			curr_lvl = 1
	get_node("/root/MainLvl").level = curr_lvl
	return curr_lvl

func scenario_exists(scenario_id) -> bool:
	var scenarioName = "scenarios/scenario_" + str(scenario_id) + ".xml"
	return FileAccess.file_exists(scenarioName)

func start_scenario(scenario_id):
	level_cleared = false
	
	if not scenario_exists(scenario_id):
		return
		
	level_id = scenario_id
	# Read the scenario file and parse it
	# The scenario is in scenarios/scenario_'scenario_id'.xml
	var parser = XMLParser.new()
	parser.open("scenarios/scenario_" + str(scenario_id) + ".xml")
	events = []  # To store Event objects
	var current_dialog_instance = null
	var to_read = true
	while true:
		if to_read:
			if parser.read() == ERR_FILE_EOF:
				break
		else:
			to_read = true
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "name":
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				level_name = attributes_dict["text"]
			if node_name == "spawn":
				var player = get_node("/root/Map/Character")
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				player.position = parse_string_to_vector3(attributes_dict["position"])
			if node_name == "event":
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				var current_event = Event.new()
				current_event.set_attributes(attributes_dict)
				events.append(current_event)
				var dialog_ctr = 0
				while parser.read() != ERR_FILE_EOF:
					if parser.get_node_type() == XMLParser.NODE_ELEMENT:
						var inner_node_name = parser.get_node_name()
						var inner_node = parser.get_node_data()

						if inner_node_name == "dialogInstance":
							var instance_attributes = {}
							for idx in range(parser.get_attribute_count()):
								instance_attributes[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
							var instance = DialogInstance.new()
							instance.set_text(instance_attributes["text"])
							instance.set_time(instance_attributes["time"].to_int())
							instance.set_id(instance_attributes["id"].to_int())
							instance.set_action(instance_attributes.get("action", ""))
							current_event.add_dialog_instance(instance)
							current_dialog_instance = instance

						elif inner_node_name == "response":
							if current_dialog_instance != null:
								var response_attributes = {}
								for idx in range(parser.get_attribute_count()):
									response_attributes[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
								var response = {}
								response["text"] = response_attributes["text"]
								response["points"] = response_attributes["points"].to_int()
								response["next"] = response_attributes["next"].to_int()
								var action = ""
								if response_attributes.has("action"):
									action = response_attributes["action"]
								response["action"] = action
								current_dialog_instance.add_response(response)
						elif inner_node_name == "event":
							to_read = false
							break


	for event in events:
		var dialogs = event.dialog_instances
		dialogs.sort_custom(func(x,y): return y.id > x.id)
		for dialog in dialogs:
			# make each response's next point to the corresponding dialog instance
			var responses = dialog.responses
			for response in responses:
				var next = response["next"]
				var nextInstance = null
				if next >= 0:
					nextInstance = dialogs[next]
				response["nextInstance"] = nextInstance 
			print(responses)
	# Sort events based on their time
	events.sort_custom(func(x,y): return y.event_attributes["time"].to_int() > x.event_attributes["time"].to_int())

	# Start the scenario 
	# Go through events and based on their time, start them
	var currTime = 0
	for event in events:
		var timeDelta = event.event_attributes["time"].to_int() - currTime
		if timeDelta > 0:
			timer = get_tree().create_timer(timeDelta)
			await timer.timeout
		currTime += timeDelta
		var current_action = event.event_attributes["action"]
		if current_action == "spawn_npc":
			# Example of NPC data: 
			# npcId="1" position="(25,9,10)" path="to_player" goal="dialog"
			var npc_id = event.event_attributes["npcId"].to_int()
			var position = event.event_attributes["position"]
			var path = event.event_attributes["path"]
			var goal = event.event_attributes["goal"]
			
			var goalPosition : Vector3
			if path != "to_player":
				goalPosition = parse_string_to_vector3(path)
			var first_dialog = null
			if event.dialog_instances.size() > 0:
				first_dialog = event.dialog_instances[0]
			if not level_cleared:
				npc_manager.spawn_npc(get_node("/root/Map"), npc_id, parse_string_to_vector3(position), goal, path == "to_player", goalPosition, event.dialog_instances[0])
			
		else:
			pass

func parse_string_to_vector3(str):
	# Remove parentheses and split by commas
	var values = str.replace("(", "").replace(")", "").split(",")

	# Convert string values to floats
	var x = values[0].to_float()
	var y = values[1].to_float()
	var z = values[2].to_float()

	# Create a Vector3 using the parsed values
	var vector3_result = Vector3(x, y, z)

	return vector3_result

var active_dialog: bool

func request_dialog(firstDialogInstance: DialogInstance, npc = null):
	if (!active_dialog):
		active_dialog = true
		dialogBox = get_node("/root/Map/Control")
		
		dialogBox.RequestDialog(firstDialogInstance, npc)

var dialogs = []
func dialog_response(dialogInstance : DialogInstance, points : int, action : String, submitAction):
	dialogs.append({"dialog": dialogInstance, "points": points})
	self.points += points
	match action:
		"end_level":
			print("ending level")
			end_level()
			return false
		"present_id":
			print("Show ID")
			#get_tree().change_scene_to_file("res://scenes/present_id.tscn")
			present_id = load("res://scenes/present_id.tscn").instantiate()
			pause_dialog()
			var idCanvas = get_node("/root/Map/IdCanvas")
			idCanvas.add_child(present_id)
			present_id.get_node("idCam").current = true
			present_id.setAction(submitAction)
			return true
		"present_fake_id":
			print("Show fake ID")
			#get_tree().change_scene_to_file("res://scenes/present_id.tscn")
			var ids = ["jean", "mickey"]
			ids.shuffle()
			present_id = load("res://scenes/present_id_" + ids[0] + ".tscn").instantiate()
			pause_dialog()
			var idCanvas = get_node("/root/Map/IdCanvas")
			idCanvas.add_child(present_id)
			present_id.get_node("idCam").current = true
			present_id.setAction(submitAction)
			return true
			
		_:
			print("Else")




func hide_id():
	if present_id != null:
		get_node("/root/Map/IdCanvas").remove_child(present_id)
		present_id.queue_free()
		resume_dialog()
		get_node("/root/Map/Character/Neck/Camera3D").current = true
		
func pause_dialog():
	dialogBox = get_node("/root/Map/Control")
	dialogBox.pause_dialog()
	dialogBox.visible = false
	
func resume_dialog():
	dialogBox = get_node("/root/Map/Control")
	dialogBox.resume_dialog()
	dialogBox.visible = true

func get_points():
	return self.points
	
var resultScreen = null

func end_level():
	if timer != null:
		timer.set_time_left(6000000) # Hack to make it so that no events happen during/after reset
	
	# Saving progress into lvl.txt
	if self.points == 0:
		var file = FileAccess.open(lvl_file, FileAccess.WRITE)
		var lvl = int(level_id)
		if scenario_exists(int(level_id) + 1):
			lvl += 1
		file.store_string(str(lvl))
		
	resultScreen = preload("res://scenes/result_screen.tscn").instantiate()
	# Get the current 2D scene tree
	var viewport = get_viewport()
	# Add the 2D result screen to the current viewport
	viewport.add_child(resultScreen)

func reset_states():
	emit_signal("dialog_state",false)
	map_instance = null
	level_cleared = true
	active_dialog = false
	npc_manager.clear_npcs()
	self.points = 0
	self.dialogs = []
	self.events = []
	if resultScreen != null:
		get_viewport().remove_child(resultScreen)
	events = []
	MainLvl.selected = false

func exit_to_menu():
	reset_states()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	return

func restart_level():
	reset_states()
	start_scenario(level_id)
	return
	
func start_next_level():
	reset_states()
	start_scenario(level_id + 1)
	return

func get_level_id():
	return self.level_id

func get_level_name():
	return self.level_name

func get_dialogs():
	return self.dialogs

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
