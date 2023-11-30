extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 100
var jump_speed = 5
var mouse_sensitivity = 0.002


func _input(event):
	if event is InputEventMouseMotion :
		rotate_y(-event.relative.x * mouse_sensitivity)
		print($Neck/Camera3D.rotation.x)
		$Neck/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Neck/Camera3D.rotation.x = clampf($Neck/Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()

