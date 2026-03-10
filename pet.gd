extends Sprite2D

@export var pet_resource: PetResource

func _ready() -> void:
	var pet = pet_resource.new()
	$TooltipBox.tooltip_name = pet.pet_name
	$TooltipBox.tooltip_description = pet.behavior.get_sound()
