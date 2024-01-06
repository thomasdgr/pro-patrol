extends CanvasLayer

var level = ["1", "2", "3"]

var level_selected = "0"
var index = 0
var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in level:
		$option_niveau.add_item(item)
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
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
