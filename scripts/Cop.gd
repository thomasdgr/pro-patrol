extends CharacterBody3D

const SPEED = 20
const STOP_DISTANCE = 35.0
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node

var goal: String
var firstDialogInstance: DialogInstance
var path: Vector3
var path_to_player: bool

@onready var anim: AnimationPlayer = $Pivot/Character/AnimationPlayer

func _ready():
	player = get_node("/root/Map/Character")  
	
func _process(delta):
	
	var destination = path
	if path_to_player and player:
		destination = player.global_transform.origin
		
	var direction = (destination - global_transform.origin).normalized()
	var opposite_dir = Vector3(-direction.x, direction.y, -direction.z)
	
	var distance = global_transform.origin.distance_to(destination)
	var look_at = opposite_dir.normalized().lerp(global_transform.basis.z.normalized(), 0.1).normalized()
	var rotation = Basis().looking_at(Vector3(look_at.x, 0, look_at.z), Vector3.UP).scaled(Vector3(0.4,0.4,0.4))
	global_transform.basis = rotation
	
	# Check if the NPC is farther than the stopping distance
	if distance > STOP_DISTANCE:
		velocity = direction * SPEED
		anim.play("BARNEY-X_Template_Biped1_skeleton|mixamo_com|Layer0")
	else:
		velocity = direction * Vector3(0,0,0)
		anim.stop()
		if goal == "dialog":
			get_node("/root/Coordinator").request_dialog(firstDialogInstance)
			
	velocity.y += -GRAVITY * delta
	move_and_slide()
