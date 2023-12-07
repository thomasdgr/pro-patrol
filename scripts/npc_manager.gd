extends Node

static func spawn_npc_scene(root_node: Node,npc_id: int, spawn_coordinates: Vector3) -> Node:
	var name: String
	var model: String
	var violence: String

	var parser = XMLParser.new()
	parser.open("scenarios/npcs/npc_" + str(npc_id) + ".xml")
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()

			if node_name == "npc":
				var attributes_dict = {}
				attributes_dict['name'] = ""
				attributes_dict['model'] = ""
				attributes_dict['violence'] = ""

				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				name = attributes_dict['name']
				model = attributes_dict['model']
				violence = attributes_dict['violence']
				break
			else:
				print("Error: Invalid npc xml file")
				break
	if name == "" or model == "":
		print("Error: Invalid npc xml file")
		return
	
	var npc_scene = load("res://scenes/npcs/" + model + ".tscn").instantiate()
	npc_scene.position = spawn_coordinates
	root_node.add_child(npc_scene)
	return npc_scene
	

# If path_to_player is true, call spawn_npc_to_player instead
# If it is false, the path vector3 represents the destination of the NPC
static func spawn_npc(root_node: Node, npc_id: int, spawn_coordinates: Vector3, goal: String, path_to_player: bool, destination: Vector3, dialogInstance: DialogInstance):
	print("Spawning npc with id:" + str(npc_id))
	var npc = spawn_npc_scene(root_node, npc_id, spawn_coordinates)
	npc.goal = goal
	npc.firstDialogInstance = dialogInstance
	npc.path = destination
	npc.path_to_player = path_to_player
	return npc
		
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
