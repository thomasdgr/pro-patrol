extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var pressed = false

func _input(event: InputEvent) -> void:
	if pressed and event is InputEventMouseMotion:
		$Cube.rotation.z += event.relative.y * 0.005
		$Cube.rotation.y += event.relative.x * 0.005
		print(event.relative)
		
	if event is InputEventMouseButton:
		pressed = !pressed
		

