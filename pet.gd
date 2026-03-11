extends Sprite2D

@export var pet_resource: PetResource = null

func _process(_delta) -> void:
	if pet_resource == null:
		return
	var pet = pet_resource.new()
	$TooltipBox.tooltip_name = pet.pet_name
	$TooltipBox.tooltip_description = pet.behavior.get_sound()
