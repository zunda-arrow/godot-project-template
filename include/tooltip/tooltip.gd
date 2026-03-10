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

@export var show_when_hovering_over: Sprite2D = null
@export var resource: TooltipResource
@export var direction: Direction = Direction.LEFT

@onready var tooltip_name = $Margins/PanelContainer/VBoxContainer/HBoxContainer/name
@onready var tooltip_description = $Margins/PanelContainer/VBoxContainer/VBoxContainer/description
@onready var icon = $Margins/PanelContainer/VBoxContainer/HBoxContainer/icon
@onready var tooltip_panel= $Margins/PanelContainer
@onready var tooltip_root = $Margins


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

	position_main_tooltip()

	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > parent_top_left.x and mouse_pos.y > parent_top_left.y and mouse_pos.x < parent_bottom_right.x and mouse_pos.y < parent_bottom_right.y:
		tooltip_panel.show()
	else:
		tooltip_panel.hide()

func position_main_tooltip():
	var parent_position: Vector2 = show_when_hovering_over.position
	var parent_size: Rect2 = show_when_hovering_over.get_rect()
	var parent_rect = Rect2(parent_position + parent_size.position, parent_size.size)

	var direction_priority_list: Array[Direction] = []
	if direction == Direction.LEFT:
		direction_priority_list = [Direction.LEFT, Direction.RIGHT]
	if direction == Direction.RIGHT:
		direction_priority_list = [Direction.RIGHT, Direction.LEFT]
	if direction == Direction.UP:
		direction_priority_list = [Direction.UP, Direction.DOWN]
	if direction == Direction.DOWN:
		direction_priority_list = [Direction.DOWN, Direction.UP]

	tooltip_root.global_position = position_single_tooltip(get_tooltip_size(), parent_rect, direction_priority_list)

func position_single_tooltip(tooltip, around, direction_priority: Array[Direction]):
	for d in direction_priority:
		var location = null
		if d == Direction.LEFT:
			location = try_place_left(tooltip, around)
		if d == Direction.RIGHT:
			location = try_place_right(tooltip, around)
		if d == Direction.UP:
			location = try_place_up(tooltip, around)
		if d == Direction.DOWN:
			location = try_place_down(tooltip, around)
		if location != null:
			return location

	return Vector2(0, 0)


func try_place_left(tooltip: Vector2, around: Rect2):
	var top_left_x = around.position.x - tooltip.x
	var top_left_y = around.position.y + around.size.y / 2 - tooltip.y / 2

	if top_left_x < 0:
		return null
	if top_left_y < 0:
		top_left_y = 0
	if top_left_y + tooltip.y >= get_viewport_size().size.y:
		top_left_y = get_viewport_size().size.y - tooltip.y

	return Vector2(top_left_x, top_left_y)

func try_place_right(tooltip: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x
	var top_left_y = around.position.y + around.size.y / 2 - tooltip.y / 2

	if top_left_x + tooltip.x > get_viewport_size().size.x:
		return null
	if top_left_y < 0:
		top_left_y = 0
	if top_left_y + tooltip.y >= get_viewport_size().size.y:
		top_left_y = get_viewport_size().size.y - tooltip.y

	return Vector2(top_left_x, top_left_y)

func try_place_up(tooltip: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x / 2 - tooltip.x / 2
	var top_left_y = around.position.y - tooltip.y

	if top_left_y < 0:
		return null
	if top_left_x < 0:
		top_left_x = 0
	if top_left_x + tooltip.x >= get_viewport_size().size.x:
		top_left_x = get_viewport_size().size.x - tooltip.x

	return Vector2(top_left_x, top_left_y)

func try_place_down(tooltip: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x / 2 - tooltip.x / 2
	var top_left_y = around.position.y + around.size.y 

	if top_left_y + tooltip.y > get_viewport_size().size.y:
		return null
	if top_left_x < 0:
		top_left_x = 0
	if top_left_x + tooltip.x >= get_viewport_size().size.x:
		top_left_x = get_viewport_size().size.x - tooltip.x

	return Vector2(top_left_x, top_left_y)

func get_viewport_size():
	# When editing, the viewport size is the size of view that we edit the level in.
	# I use 1920x1080 instead because we hardcode that for our project and it looks correct.
	if Engine.is_editor_hint():
		return Rect2(Vector2(0, 0), Vector2(1920, 1080))
	return get_viewport().get_visible_rect()

func get_tooltip_size():
	if tooltip_panel:
		return tooltip_panel.size
	return Vector2(0.,0.)
