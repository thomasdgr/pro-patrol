extends Node

var points = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_scenario(1)
	pass # Replace with function body.

func start_scenario(scenario_id):
	# Read the scenario file and parse it
	# The scenario is in scenarios/scenario_'scenario_id'.xml
	var parser = XMLParser.new()
	parser.open("scenarios/scenario_" + str(scenario_id) + ".xml")
	var events = []  # To store Event objects

	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()

			if node_name == "event":
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)

				var current_event = Event.new()
				current_event.set_attributes(attributes_dict)
				events.append(current_event)

				while parser.read() != ERR_FILE_EOF:
					if parser.get_node_type() == XMLParser.NODE_ELEMENT:
						var inner_node_name = parser.get_node_name()

						if inner_node_name == "dialogInstance":
							var instance_attributes = {}
							instance_attributes["action"] = ""
							for idx in range(parser.get_attribute_count()):
								instance_attributes[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)

							var instance = DialogInstance.new()
							instance.set_text(instance_attributes["text"])
							instance.set_time(instance_attributes["time"].to_int())
							instance.set_id(instance_attributes["id"].to_int())
							instance.set_next_index(instance_attributes["next"].to_int())
							instance.set_action(instance_attributes["action"])
							current_event.add_dialog_instance(instance)

		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END and parser.get_node_name() == "event":
			break  # End processing the current event

	for event in events:
		var dialogs = event.dialog_instances
		dialogs.sort_custom(lambda x: x.id, false)
		for dialog in dialogs:
			dialog.set_next_instance(dialogs[dialog.next_instance])

	# Sort events based on their time
	events.sort_custom(lambda x: x.event_attributes["time"].to_int(), false)

	# Start the scenario 
	# Go through events and based on their time, start them
	for event in events:
		current_action = event.event_attributes["action"]
		if current_action == "spawn_npc":
			# Example of NPC data: 
			# npcId="1" position="(25,9,10)" path="to_player" goal="dialog"
			var npc_id = event.event_attributes["npcId"]
			var position = event.event_attributes["position"]
			var path = event.event_attributes["path"]
			var goal = event.event_attributes["goal"]
			# spawn_npc()
		else:
			pass

func add_points(points: int):
	self.points += points

func get_points():
	return self.points

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
