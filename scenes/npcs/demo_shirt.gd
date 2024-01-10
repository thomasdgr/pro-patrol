extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func walk():
	print("walk walk")
	$AnimationPlayer.play("Walk")
	
func set_texture(png_path):
	print(png_path)
	$Root/Skeleton3D/Character_BusinessMan_Shirt.set_texture(png_path)

