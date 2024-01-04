extends CanvasLayer

var audio_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Label/CheckButton").toggled.connect(_on_checked)
	audio_player = $AudioStreamPlayer  # Assurez-vous de remplacer 'AudioStreamPlayer' par le nom correct de votre nœud AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_checked(btn_pressed):
	if btn_pressed:
		print("check_pressed")
		audio_player.play()  # Lancez la lecture de la musique
	else:
		print("check_pressed")
		audio_player.stop()  # Arrêtez la lecture de la musique
