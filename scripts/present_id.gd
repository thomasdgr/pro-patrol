extends Node3D

var button_end: Button
# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	button_end = get_node("/root/present_id/Control/Button")
	button_end.pressed.connect(_on_button_pressed.bind(button_end), 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed(button: Button):
	match button:
		button_end:
			handle_button_click(button_end)
		# Add more buttons as needed

func Show_id():
	show()

func handle_button_click(button: Button):
	print("Button clicked:", button.text)
	#get_tree().change_scene_to_file("res://scenes/map.tscn")
	#hide()
# ...
