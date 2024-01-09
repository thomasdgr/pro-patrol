extends StaticBody3D

@onready var animation_player = $MovingPnj/Path3D/PathFollow3D
@onready var animation_player2 = $MovingPnj/Path3D2/PathFollow3D
# Called when the node enters the scene tree for the first time.


func _ready():
	get_node("/root/Coordinator").start_scenario(MainLvl.level) 
	var emitter = get_node("Control")
	emitter.dialog_state.connect(check_dialog)
	
	var resultScreen = preload("res://scenes/npcs/demo_shirt.tscn").instantiate()
	var resultScreen2 = preload("res://scenes/npcs/demo_shirt.tscn").instantiate()
	animation_player.add_child(resultScreen)
	animation_player2.add_child(resultScreen2)
	animation_player.get_child(0).walk()
	animation_player2.get_child(0).walk()
	print()
	pass # Replace with function body.

func check_dialog(value):
	print("signal received map : ", value)
	$Character.camera_state(value);

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta) -> void:
	const move_speed = 2.0
	$MovingPnj/Path3D/PathFollow3D.progress += move_speed * delta
	$MovingPnj/Path3D2/PathFollow3D.progress += move_speed * delta
	

