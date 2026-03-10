extends Control

@export var tooltip_name: String = "Name"
@export var tooltip_description: String = "Example tooltip description"

func _ready() -> void:
	$VBoxContainer/HBoxContainer/name.text = tooltip_name
	$VBoxContainer/VBoxContainer/description.text = tooltip_description
