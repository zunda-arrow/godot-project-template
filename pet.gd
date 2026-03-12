extends Sprite2D

@export var pet_resource: PetResource = null

func _process(_delta) -> void:
	if pet_resource == null:
		return
	var pet = pet_resource.new()
