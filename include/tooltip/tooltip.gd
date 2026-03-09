@tool
extends Control
class_name Tooltip

# Offset the y height of the hints. This can be
# used to properly center the hints panel for a graphic.
const HINTS_Y_OFFSET = 0

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN,
}

@export var show_when_hovering_over: Node2D = null
@export var resource: TooltipResource
@export var direction: Direction = Direction.LEFT

@onready var tooltip_name = $Margins/PanelContainer/VBoxContainer/HBoxContainer/name
@onready var tooltip_description = $Margins/PanelContainer/VBoxContainer/VBoxContainer/description
@onready var icon = $Margins/PanelContainer/VBoxContainer/HBoxContainer/icon
@onready var tooltip = $Margins/PanelContainer

var displayed_hints: Array[Node] = []

func _ready():
	if resource == null:
		return

	tooltip_name.text = resource.label
	tooltip_description.text = resource.description

	if resource.icon != null:
		icon = resource.icon
		icon.show()

	for hint in displayed_hints:
		hint.queue_free()
	displayed_hints = []

func _process(_delta: float):
	if show_when_hovering_over == null:
		return

	# We set the position in process so moving objects keep
	# the correct tooltip positions
	var parent_position: Vector2 = show_when_hovering_over.position
	var parent_size: Rect2 = show_when_hovering_over.get_rect()
	var parent_top_left = parent_position + parent_size.position
	var parent_bottom_right = parent_position + parent_size.end

	position_tooltip()

	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > parent_top_left.x and mouse_pos.y > parent_top_left.y and mouse_pos.x < parent_bottom_right.x and mouse_pos.y < parent_bottom_right.y:
		tooltip.show()
	else:
		tooltip.hide()

func position_tooltip():
	var parent_position: Vector2 = show_when_hovering_over.position
	var parent_size: Rect2 = show_when_hovering_over.get_rect()

	var parent_top_left = parent_position + parent_size.position
	var parent_bottom_right = parent_position + parent_size.end

	var tooltip_size = get_tooltip_size()

	var center_horizontal = parent_top_left.x + ((parent_size.end.x - parent_size.position.x) / 2)
	var center_vertical = parent_top_left.y + ((parent_size.end.y - parent_size.position.y) / 2)

	if direction == Direction.LEFT:
		position_left(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, false)
	if direction == Direction.RIGHT:
		position_right(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, false)
	if direction == Direction.UP:
		position_top(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, false)
	if direction == Direction.DOWN:
		position_bottom(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, false)

func position_left(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, fail_if_repeat):
	if (parent_top_left.x - tooltip_size.x < 0):
		if fail_if_repeat:
			return
		position_right(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, true)
		return
	tooltip.global_position.x = parent_top_left.x - tooltip_size.x
	tooltip.global_position.y = parent_top_left.y

func position_right(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, fail_if_repeat):
	var screen_size = get_viewport().get_visible_rect().size

	if (parent_bottom_right.x + tooltip_size.x > screen_size.x):
		if fail_if_repeat:
			return
		position_left(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, true)
		return
	tooltip.global_position.x = parent_bottom_right.x
	tooltip.global_position.y = parent_top_left.y

func position_top(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, fail_if_repeat):
	if (parent_top_left.y - tooltip_size.y < 0):
		if fail_if_repeat:
			return
		position_bottom(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, true)
		return

	tooltip.global_position.x = center_horizontal - tooltip_size.x / 2
	tooltip.global_position.y = parent_top_left.y - tooltip_size.y

func position_bottom(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, fail_if_repeat):
	var screen_size = get_viewport().get_visible_rect().size

	if (parent_bottom_right.y + tooltip_size.y > screen_size.y):
		if fail_if_repeat:
			return
		position_top(parent_top_left, parent_bottom_right, center_vertical, center_horizontal, tooltip_size, true)
		return
	tooltip.global_position.x = center_horizontal - tooltip_size.x / 2
	tooltip.global_position.y = parent_bottom_right.y

func get_tooltip_size():
	if tooltip:
		return tooltip.size
	return Vector2(0.,0.)
