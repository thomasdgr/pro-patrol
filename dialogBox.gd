extends Control

var dialogNode : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# make invisible
	dialogNode = get_node("/root/Map/Control")  
	dialogNode.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func RequestDialog(dialog_id):
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
