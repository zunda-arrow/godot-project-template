extends CenterContainer

@onready var menu = $MainMenu
@onready var options = $Options

func _ready() -> void:
	menu.show()
	options.hide()

func start_pressed() -> void:
	print("Starting the game")

func options_pressed() -> void:
	options.show()
	menu.hide()

func options_back_pressed() -> void:
	menu.show()
	options.hide()

func quit_pressed() -> void:
	get_tree().quit()
