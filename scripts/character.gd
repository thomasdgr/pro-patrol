extends CharacterBody3D


	
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_speed = 15

var jump_speed = 5
var mouse_sensitivity = 0.002

var direction = Vector3.ZERO

var lerp_speed = 10.0
var is_camera_movable = true

func _ready():
	is_camera_movable = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion && is_camera_movable == true :
		rotate_y(-event.relative.x * mouse_sensitivity)
		#print($Neck/Camera3D.rotation.x)
		$Neck/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Neck/Camera3D.rotation.x = clampf($Neck/Camera3D.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	var input = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input.x, 0, input.y)).normalized(),delta * lerp_speed) 
	if direction  && is_camera_movable == true :
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x,0,current_speed)
		velocity.z = move_toward(velocity.z,0,current_speed)
	
	move_and_slide()
	
func camera_state(value):
	print("stop camera character : ", value)
	is_camera_movable = !value

