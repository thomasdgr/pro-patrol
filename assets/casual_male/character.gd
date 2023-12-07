extends Node3D


@onready var anim: AnimationPlayer = get_node("AnimationPlayer")


func _ready():
	anim.play("walking")
