extends TestScene

func get_scene() -> PackedScene:
	return load("res://game/game.tscn")

func setup(scene: Node):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://icon.svg")
	scene.add_child(sprite)

	print("There should be a little godot guy in the corner")
