extends TestScene

# This is an example test that starts the game scene

func get_scene() -> PackedScene:
	return load("res://game/game.tscn")

func setup(scene: Node):
	print("There should be a little godot guy in the corner")
