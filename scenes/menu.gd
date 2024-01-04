extends CanvasLayer

var audio_player : AudioStreamPlayer

var niveau = ["1", "2", "3", "4", "5"]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Label/btn_music").toggled.connect(_on_checked)
	get_node("Label/btn_exit").toggled.connect(_on_checked_exit)
	get_node("Label/btn_start").toggled.connect(_on_checked_start)
	get_node("Label/btn_niveau").toggled.connect(_on_checked_level)

	audio_player = $AudioStreamPlayer  # Assurez-vous de remplacer 'AudioStreamPlayer' par le nom correct de votre nœud AudioStreamPlayer

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
		print(main_lvl.level)
		# je veux la variable ici du script level_pop
		# ----------- Change ici la scène pour le clic sur start ------------
		#get_tree().change_scene_to_file("res://menu.tscn")
		
		
func _on_checked_level(btn_pressed):
	if btn_pressed:
		print("hi")
		get_tree().change_scene_to_file("res://level_pop.tscn")
