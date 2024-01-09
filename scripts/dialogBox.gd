extends Control

signal dialog_state

var dialogNode : Node

var countdown_timer: float = 10
var timer_running: bool = false
var label_timer: RichTextLabel
var label_title: RichTextLabel
var label_question: RichTextLabel

var buttonData = {}

var button1: Button
var button2: Button
var button3: Button
var is_dialog_active: bool = false;


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
	button1.pressed.connect(_on_button_pressed.bind(button1), 0)
	button2.pressed.connect(_on_button_pressed.bind(button2), 1)
	button3.pressed.connect(_on_button_pressed.bind(button3), 2)

	
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
			get_node("/root/Coordinator").dialog_response(dialog, buttonData[button1].points, buttonData[button1].action)
			if buttonData[button1].nextInstance != null:
				RequestDialog(buttonData[button1].nextInstance)
			return

func RequestDialog(dialog_id: DialogInstance):
	if dialog_id == null:


		return
	if true:
		dialog = dialog_id
		if (len(dialog.responses) == 0):
			
			print("FIND REESSAYER")
			hide()
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			return
		is_dialog_active = true
		emit_signal("dialog_state",is_dialog_active)

		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		countdown_timer = dialog_id.time
		label_title.text = "Question " + String.num_int64(dialog_id.id +1)
		label_question.text = dialog_id.text
		
		button1.text = dialog_id.responses[0].text
		button1.visible = true
		
		buttonData[button1] = {
			"nextInstance": dialog_id.responses[0].nextInstance,
		 	"points": dialog_id.responses[0].points,
			"action": dialog_id.responses[0].action,
		}
		
		if len(dialog_id.responses) <= 1:
			button2.visible = false
		else:
			button2.visible = true
			button2.text = dialog_id.responses[1].text
			buttonData[button2] = {
				"nextInstance": dialog_id.responses[1].nextInstance,
		 		"points": dialog_id.responses[1].points,
				"action": dialog_id.responses[1].action,
			}	
		
		if len(dialog_id.responses) <= 2:
			button3.visible = false
		else:
			button3.visible = true
			button3.text = dialog_id.responses[2].text
			buttonData[button3] = {
				"nextInstance": dialog_id.responses[2].nextInstance,
		 		"points": dialog_id.responses[2].points,
				"action": dialog_id.responses[2].action,
			}	
	
		start_timer()
		dialogNode.visible = true
		
	
	# Show the dialog and set the proper flags 
	
func start_timer() -> void:
	timer_running = true

func stop_timer() -> void:
	timer_running = false


# Called when any button is pressed
func _on_button_pressed(button: Button):
	match button:
		button1:
			handle_button_click(button1)
		button2:
			handle_button_click(button2)
		button3:
			handle_button_click(button3)
		# Add more buttons as needed

func handle_button_click(button: Button):
	print("Button clicked:", button.text)
	get_node("/root/Coordinator").dialog_response(dialog, buttonData[button].points, buttonData[button].action)
	if buttonData[button].nextInstance != null:
		RequestDialog(buttonData[button].nextInstance)
	else:
		hide()
# ...

func reset_dialog():
	button1.visible = false
	button2.visible = false
	button3.visible = false
	
