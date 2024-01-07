extends CanvasLayer

var levels = []

var level_selected = "0"
var index = 0
var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var coordinator = get_node("/root/Coordinator")
	levels = coordinator.get_scenario_list()
	for item in levels:
		print(item)
		$option_niveau.add_item(item[0])
		if item[1] == false:
			print(item[0])
			$option_niveau.set_item_disabled(int(item[0])-1, true)
	get_node("btn_validation").toggled.connect(_on_checked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_checked(btn_pressed):
	if btn_pressed:
		print("okay")
		id = $option_niveau.get_selected_id()
		index = $option_niveau.get_item_index(id)
		level_selected = $option_niveau.get_item_text(index)
		print(level_selected)
		$"/root/MainLvl".level = level_selected
		$"/root/MainLvl".selected = true
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
