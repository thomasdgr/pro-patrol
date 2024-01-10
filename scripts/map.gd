extends StaticBody3D

@onready var animation_players : Array = []
@onready var animation_cars : Array = []
@onready var city_sound : AudioStreamPlayer = $city_ambiance

var texture_pnj_list : Array = ["PolygonCity_Texture_01_B.png","PolygonCity_Texture_01_C.png","PolygonCity_Texture_02_A.png","PolygonCity_Texture_02_B.png","PolygonCity_Texture_02_C.png","PolygonCity_Texture_03_A.png","PolygonCity_Texture_03_B.png","PolygonCity_Texture_03_C.png","PolygonCity_Texture_04_A.png","PolygonCity_Texture_04_B.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Coordinator").start_scenario(MainLvl.level) 
	var emitter = get_node("Control")
	emitter.dialog_state.connect(check_dialog)
	city_sound.play()
	display_cars()
	display_pnj()
	print("Added", animation_players.size(), "PNJs")

func display_cars():
	var pnj_scene = null
	for i in range(2): # Change this range to the number of PNJ you want
		if(i %2):
			pnj_scene = preload("res://scenes/vehicule/Bus.tscn")
		else:
			pnj_scene = preload("res://scenes/vehicule/Car.tscn")
			
		
		var pnj_instance = pnj_scene.instantiate()
		print("MovingVehicule/Path3D" + str(i + 1) + "/PathFollow3D")
		var animation_car = get_node("MovingVehicule/Path3D" + str(i + 1) + "/PathFollow3D")
		
		var random_offset = randf() # Generate a random offset between 0 and 1

		
		animation_car.add_child(pnj_instance)
		
		
		animation_car.progress = random_offset * 100
		animation_cars.append(animation_car)
	
func display_pnj():
	for i in range(19): # Change this range to the number of PNJ you want
		var pnj_scene = preload("res://scenes/npcs/demo_shirt.tscn")
		var pnj_instance = pnj_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		var animation_player = get_node("MovingPnj/Path3D" + str(i + 1) + "/PathFollow3D")
		
		var random_offset = randf() # Generate a random offset between 0 and 1
		var random_texture_index = randi() % texture_pnj_list.size() # Get a random index from your texture_pnj_list
		var texture_path : String = "res://SourceFiles/Textures/" + texture_pnj_list[random_texture_index]

		animation_player.add_child(pnj_instance)
		
		# Set the texture for the PNJ
		animation_player.get_child(0).set_texture(texture_path)
		
		animation_player.get_child(0).walk()
		animation_player.progress = random_offset * 100
		animation_players.append(animation_player)

		
func check_dialog(value):
	print("signal received map : ", value)
	$Character.camera_state(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta) -> void:
	const move_speed_pnj = 1.0
	const move_speed_car = 5.0
	for animation_player in animation_players:
		animation_player.progress -= move_speed_pnj * delta
	
	for animation_car in animation_cars:
		animation_car.progress += move_speed_car * delta
