extends StaticBody3D

@onready var animation_players : Array = []
@onready var animation_cars : Array = []
@onready var city_sound : AudioStreamPlayer = $city_ambiance

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
	

	for i in range(5): # Change this range to the number of PNJ you want
		var random_index_vehicule = randi_range(1,3) # Generate a random offset between 0 and 1
		pnj_scene = load("res://scenes/vehicule/vehicule"+ str(random_index_vehicule) +".tscn")
		var pnj_instance = pnj_scene.instantiate()
		print("MovingVehicule/Path3D" + str(i + 1) + "/PathFollow3D")
		var animation_car = get_node("MovingVehicule/Path3D" + str(random_index_vehicule) + "/PathFollow3D")
		
		var random_offset = randf() # Generate a random offset between 0 and 1

		
		animation_car.add_child(pnj_instance)
		
		
		animation_car.progress = random_offset * 100
		animation_cars.append(animation_car)
	
func display_pnj():
	var pnj_scene
	for i in range(24): # Change this range to the number of PNJ you want
		
		var random_index_pnj = randi_range(1,9) # Generate a random offset between 0 and 1
	
		pnj_scene = load("res://scenes/npcs/pnj/pnj" + str(random_index_pnj) +".tscn")
		
		var pnj_instance = pnj_scene.instantiate()
		var animation_player = get_node("MovingPnj/Path3D" + str(i + 1) + "/PathFollow3D")
		var random_offset = randf() # Generate a random offset between 0 and 1

		animation_player.add_child(pnj_instance)
		
		animation_player.get_child(0).walk()
		animation_player.progress = random_offset * 100
		animation_players.append(animation_player)

		
func check_dialog(value):
	print("signal received map : ", value)
	$Character.camera_state(value)

# Called every frame. 'delta' is theelapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta) -> void:
	const move_speed_pnj = 1.0
	const move_speed_car = 5.0
	for animation_player in animation_players:
		animation_player.progress -= move_speed_pnj * delta
	
	for animation_car in animation_cars:
		animation_car.progress += move_speed_car * delta
