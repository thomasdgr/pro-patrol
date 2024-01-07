extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var coordinator = get_node("/root/Coordinator")
	var dialogs = coordinator.get_dialogs()
	var success = true
	
	get_node("TextureRect/ContentBox/Title/MissionName").text = coordinator.get_level_name()
	
	for dialog in dialogs:
		if dialog.points > 0:
			success = false
			break
			
	var badge : TextureRect = get_node("TextureRect/ContentBox/Title/BadgeImg")
	
	if success:
		badge.set_texture(load("res://assets/png/PASS.png"))
	else:
		badge.set_texture(load("res://assets/png/FAIL.png"))
	
	# We need to insert labels into the Recap for each dialog
	var recapNode = get_node("TextureRect/ContentBox/Recap")
	for n in recapNode.get_children():
		recapNode.remove_child(n)
		n.queue_free()
		
	for dialog in dialogs:
		var label = Label.new()
		label.text = dialog.dialog.text
		label.text += "...."
		if dialog.points > 0:
			label.self_modulate = Color("e62802")
			label.text += "FAIL"
		else:
			label.self_modulate = Color("4efc03")
			label.text += "OK"
		recapNode.add_child(label)
		
	# if success the player should be able to progress to the next level (if there is one)
	# if fail, then player should be able to restart the current level
	# in both cases there should be an exit to main menu button
	# We should also store the progress in some file. Maybe a json or maybe something less "modifiable"
	
	var contentBox : VBoxContainer = get_node("TextureRect/ContentBox")
	var hBox : HBoxContainer = HBoxContainer.new()
	var exitButton = Button.new()
	exitButton.pressed.connect(_exit_button_pressed)
	exitButton.text = "Retourner au Menu"
	hBox.add_child(exitButton)
	hBox.add_spacer(true)
	var next_exists = coordinator.scenario_exists(int(coordinator.get_level_id()) + 1)
	if not success:
		var retryButton = Button.new()
		retryButton.text = "Réessayer"
		retryButton.pressed.connect(_retry_button_pressed)
		hBox.add_child(retryButton)
	elif next_exists:
		var continueButton = Button.new()
		continueButton.text = "Niveau Suivant"
		continueButton.pressed.connect(_next_button_pressed)
		hBox.add_child(continueButton)
	contentBox.add_child(hBox)
	pass # Replace with function body.

func _exit_button_pressed():
	var coordinator = get_node("/root/Coordinator")
	coordinator.exit_to_menu()	
	return
	
func _retry_button_pressed():
	var coordinator = get_node("/root/Coordinator")
	coordinator.restart_level()
	return
	
func _next_button_pressed():
	var coordinator = get_node("/root/Coordinator")
	coordinator.start_next_level()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
