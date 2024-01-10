extends CharacterBody3D

const SPEED = 2
const STOP_DISTANCE = 3.0
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node

var goal: String
var firstDialogInstance: DialogInstance
var path: Vector3
var path_to_player: bool
var dialogActive: bool

@onready var anim: AnimationPlayer = $Pivot/business_shirt/AnimationPlayer
#@onready var footstep : AudioStreamPlayer3D = $Pivot/business_shirt/footstep


func _ready():
	player = get_node("/root/Map/Character")
	
func _process(delta):
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		
	
	var destination = path
	if path_to_player and player:
		destination = player.global_transform.origin
	var distance = global_transform.origin.distance_to(destination)
	
	
	var direction = (destination - global_transform.origin).normalized()
	var opposite_dir = Vector3(-direction.x, direction.y, -direction.z)
	if distance <= STOP_DISTANCE:
		direction = (destination - global_transform.origin).normalized()
		opposite_dir = Vector3(-direction.z, direction.y, direction.x)
	
	var look_at = opposite_dir.normalized().lerp(global_transform.basis.z.normalized(), 0.1).normalized()
	var rotation = Basis().looking_at(Vector3(look_at.x, 0, look_at.z), Vector3.UP).scaled(Vector3(1,1,1))
	global_transform.basis = rotation
	
	# Check if the NPC is farther than the stopping distance
	if distance > STOP_DISTANCE:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		#anim.play("Walk")
		anim.play("Walk")
	else:
		velocity = direction * Vector3(0,0,0)
		
		anim.play("Talk")
		if goal == "dialog" && !dialogActive:
			dialogActive = true
			get_node("/root/Coordinator").request_dialog(firstDialogInstance, self)

	move_and_slide()
