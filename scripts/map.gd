extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Coordinator").start_scenario(1) 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta) -> void:
	const move_speed = 5.0
	#Path3D/PathFollow3D.progress += move_speed * delta
	pass
