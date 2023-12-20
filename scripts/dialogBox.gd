extends Control

var dialogNode : Node

var countdown_timer: float = 10
var timer_running: bool = false
var label_timer: RichTextLabel
var label_title: RichTextLabel
var label_question: RichTextLabel
var button1: Button
var button2: Button
var button3: Button

var dialog: DialogInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	# make invisible
	dialogNode = get_node("/root/Map/Control") 
	label_timer = get_node("/root/Map/Control/Dialog/Timer")
	label_title = get_node("/root/Map/Control/Dialog/Title")
	label_question = get_node("/root/Map/Control/Dialog/Question")
	button1 = get_node("/root/Map/Control/Dialog/VBoxContainer/Button")
	button2 = get_node("/root/Map/Control/Dialog/VBoxContainer/Button2")
	button3 = get_node("/root/Map/Control/Dialog/VBoxContainer/Button3")
	
	dialogNode.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_running:
		countdown_timer -= delta
		label_timer.text = String.num_scientific(countdown_timer);
		if countdown_timer <= 0:
			print("Le minuteur a atteint 0 !")
			stop_timer()
			print(dialog.responses)
			print("Next")
			var t =  dialog.responses[0].nextInstance
			print(t.responses)
			hide()
			RequestDialog(dialog.responses[0].nextInstance)
			return

func RequestDialog(dialog_id: DialogInstance):
	if !timer_running:
		dialog = dialog_id
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		countdown_timer = dialog_id.time
		label_title.text = "Question " + String.num_int64(dialog_id.id +1)
		label_question.text = dialog_id.text
		button1.text = dialog_id.responses[0].text
		button2.text = dialog_id.responses[1].text
		
		if len(dialog_id.responses) <= 2:
			button3.visible = false
		else:
			button3.text = dialog_id.responses[2].text
	
		start_timer()
		dialogNode.visible = true
		
		
		
	
	# If dialog is active:
	#	Do nothing (npc will request on every _process call
	# If it isn't:
	#	Populate the dialogue
	#	Populate the timer
	#	Populate the answers 
	# If there are 3 answers:
	#	[ ANSWER 1 ] [ ANSWER 2 ]
	#			[ ANSWER 3 ] <- This 3 and the other 3 should be seperate nodes, so that we don't have to move them
	# If there are 4 answers:
	#	[ ANSWER 1 ] [ ANSWER 2 ]
	#	[ ANSWER 3 ] [ ANSWER 4 ]
	# If there are 2 answers:
	#	[ ANSWER 1 ] [ ANSWER 2 ]
	
	# Show the dialog and set the proper flags 
	
func start_timer() -> void:
	timer_running = true

func stop_timer() -> void:
	timer_running = false

func _on_button_pressed():
	print("Ok")
	pass
