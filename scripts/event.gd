class_name Event

extends Node

var event_attributes : Dictionary
var dialog_instances : Array

func _init():
	event_attributes = {}
	dialog_instances = []

func set_attributes(attributes: Dictionary):
	event_attributes = attributes

func add_dialog_instance(dialog_instance: DialogInstance):
	dialog_instances.append(dialog_instance)
