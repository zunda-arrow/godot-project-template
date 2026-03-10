extends Control

@export var tooltip_name: String = "Name"
@export var tooltip_description: String = "Example tooltip description"

func _ready() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/name.text = tooltip_name
	$PanelContainer/VBoxContainer/VBoxContainer/description.text = tooltip_description
