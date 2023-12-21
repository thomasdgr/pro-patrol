extends Node

var points = 0
var npc_manager = preload("res://scripts/npc_manager.gd")
var dialogBox : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	dialogBox = get_node("/root/Map/Control")
	start_scenario(1)
	pass # Replace with function body.

func start_scenario(scenario_id):
	# Read the scenario file and parse it
	# The scenario is in scenarios/scenario_'scenario_id'.xml
	var parser = XMLParser.new()
	parser.open("scenarios/scenario_" + str(scenario_id) + ".xml")
	var events = []  # To store Event objects
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
			await get_tree().create_timer(timeDelta).timeout
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
				
			npc_manager.spawn_npc(get_node("/root/Map"), npc_id, parse_string_to_vector3(position), goal, path == "to_player", goalPosition, event.dialog_instances[0])
			
		else:
			pass

func parse_string_to_vector3(str):
	# Remove parentheses and split by commas
	var values = str.replace("(", "").replace(")", "").split(",")

	# Convert string values to floats
	var x = values[0].to_float()
	var y = 0
	var z = values[2].to_float()

	# Create a Vector3 using the parsed values
	var vector3_result = Vector3(x, y, z)

	return vector3_result

var active_dialog: bool

func request_dialog(firstDialogInstance: DialogInstance):
	# Call the other function

	#print("Hey")
	
	#print(firstDialogInstance)
	if (!active_dialog):
		active_dialog = true
		dialogBox.RequestDialog(firstDialogInstance)

var dialogs = []
func dialog_response(dialogInstance : DialogInstance, points : int, action : String):
	dialogs.append({"dialog": dialogInstance, "points": points})
	points += points
	match action:
		"end_level":
			print("ending level")
		_:
			print("Else")
			

func get_points():
	return self.points

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
