class_name DialogInstance

extends Node

# Define the DialogInstance fields
var text : String
var responses : Array
var id : int
var next_instance : DialogInstance = null
var time : int
var action : String
var next_index : int

func _init():
	text = ""
	responses = []
	next_instance = null
	next_index = -1
	time = 0
	id = -1
	action = ""

func set_text(new_text: String):
	text = new_text

func add_response(response_text: String, points: int):
	responses.append({"text": response_text, "points": points})

func set_next_instance(instance: DialogInstance):
	next_instance = instance

func set_time(new_time: int):
	time = new_time

func set_id(new_id: int):
	id = new_id

func set_next_index(new_index: int):
	next_index = new_index

func set_action(new_action: String):
	action = new_action
