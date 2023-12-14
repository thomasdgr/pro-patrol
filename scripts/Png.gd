extends CharacterBody3D

const SPEED = 8
const STOP_DISTANCE = 5.0
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node

var dialogBox : Node

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	player = get_node("/root/Map/Character")  
	dialogBox = get_node("/root/Map/Control")
	
func _process(delta):
	
	if not is_on_floor() :
		velocity.y -= GRAVITY * delta
		
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		var opposite_dir = Vector3(-direction.x, direction.y, -direction.z)
		
		var distance = global_transform.origin.distance_to(player.global_transform.origin)


		var look_at = opposite_dir.normalized().lerp(global_transform.basis.z.normalized(), 0.1).normalized()
		var rotation = Basis().looking_at(Vector3(look_at.x, 0, look_at.z), Vector3.UP).scaled(Vector3(1,1,1))
		global_transform.basis = rotation
		
		# Check if the NPC is farther than the stopping distance
		if distance > STOP_DISTANCE:
			
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# Move towards the player
			anim.play("walking")
		else:
			var dialog: DialogInstance = DialogInstance.new()
			dialog.set_id(1)
			dialog.set_text("Choose")
			dialog.set_time(40)
			dialog.add_response("Boulette", 10)
			dialog.add_response("Mini boulette", 5)
			dialog.add_response("Micro boulette", 2)
			
			dialogBox.RequestDialog(dialog)
			velocity = direction * Vector3(0,0,0)
			anim.stop()
			# Initiate Conversation
	velocity.y += -GRAVITY * delta
	move_and_slide()
