class_name DialogInstance

extends Node

# Define the DialogInstance fields
var text : String
var responses : Array
var id : int
var time : int
var action : String

func _init():
	text = ""
	responses = []
	time = 0
	id = -1
	action = ""

func set_text(new_text: String):
	text = new_text

func add_response(response:Dictionary):
	responses.append(response)

func set_time(new_time: int):
	time = new_time

func set_id(new_id: int):
	id = new_id

func set_action(new_action: String):
	action = new_action
