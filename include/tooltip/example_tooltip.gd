extends Control

@export var tooltip_name: String = "Name"
@export var tooltip_description: String = "Example tooltip description"

func _process(delta) -> void:
	$VBoxContainer/HBoxContainer/name.text = tooltip_name
	$VBoxContainer/VBoxContainer/description.text = tooltip_description
