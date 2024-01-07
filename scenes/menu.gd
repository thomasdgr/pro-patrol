extends CanvasLayer

var audio_player : AudioStreamPlayer
static var selected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if not MainLvl.selected:
		get_node("/root/Coordinator").get_current_level()
	get_node("Label/btn_music").toggled.connect(_on_checked)
	get_node("Label/btn_exit").toggled.connect(_on_checked_exit)
	get_node("Label/btn_start").toggled.connect(_on_checked_start)
	get_node("Label/btn_niveau").toggled.connect(_on_checked_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_checked(btn_pressed):
	if btn_pressed:
		print("music on")
		audio_player.play()  # Lancez la lecture de la musique
	else:
		print("music off")
		audio_player.stop()  # Arrêtez la lecture de la musique
		
func _on_checked_exit(btn_pressed):
	if btn_pressed:
		print("exit")
		get_tree().quit()
		
func _on_checked_start(btn_pressed):
	if btn_pressed:
		print("hi")
		print($"/root/MainLvl".level)
		# je veux la variable ici du script level_pop
		# ----------- Change ici la scène pour le clic sur start ------------
		#get_tree().change_scene_to_file("res://menu.tscn")
		get_tree().change_scene_to_file("res://scenes/map.tscn")
		
		
func _on_checked_level(btn_pressed):
	if btn_pressed:
		print("hi")
		get_tree().change_scene_to_file("res://scenes/level_pop.tscn")
