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
@export var direction: Direction = Direction.LEFT

@export var tooltip: Control


var displayed_hints: Array[Node] = []

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
		tooltip.show()
	else:
		tooltip.hide()

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

	if tooltip == null:
		return

	tooltip.global_position = position_single_tooltip(get_tooltip_size(), parent_rect, direction_priority_list)

func position_single_tooltip(tooltip_size, around, direction_priority: Array[Direction]):
	for d in direction_priority:
		var location = null
		if d == Direction.LEFT:
			location = try_place_left(tooltip_size, around)
		if d == Direction.RIGHT:
			location = try_place_right(tooltip_size, around)
		if d == Direction.UP:
			location = try_place_up(tooltip_size, around)
		if d == Direction.DOWN:
			location = try_place_down(tooltip_size, around)
		if location != null:
			return location

	return Vector2(0, 0)


func try_place_left(tooltip_size: Vector2, around: Rect2):
	var top_left_x = around.position.x - tooltip_size.x
	var top_left_y = around.position.y + around.size.y / 2 - tooltip_size.y / 2

	if top_left_x < 0:
		return null
	if top_left_y < 0:
		top_left_y = 0
	if top_left_y + tooltip_size.y >= get_viewport_size().size.y:
		top_left_y = get_viewport_size().size.y - tooltip_size.y

	return Vector2(top_left_x, top_left_y)

func try_place_right(tooltip_size: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x
	var top_left_y = around.position.y + around.size.y / 2 - tooltip_size.y / 2

	print(tooltip_size)

	if top_left_x + tooltip_size.x > get_viewport_size().size.x:
		return null
	if top_left_y < 0:
		top_left_y = 0
	if top_left_y + tooltip_size.y >= get_viewport_size().size.y:
		top_left_y = get_viewport_size().size.y - tooltip_size.y

	return Vector2(top_left_x, top_left_y)

func try_place_up(tooltip_size: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x / 2 - tooltip_size.x / 2
	var top_left_y = around.position.y - tooltip_size.y

	if top_left_y < 0:
		return null
	if top_left_x < 0:
		top_left_x = 0
	if top_left_x + tooltip_size.x >= get_viewport_size().size.x:
		top_left_x = get_viewport_size().size.x - tooltip_size.x

	return Vector2(top_left_x, top_left_y)

func try_place_down(tooltip_size: Vector2, around: Rect2):
	var top_left_x = around.position.x + around.size.x / 2 - tooltip_size.x / 2
	var top_left_y = around.position.y + around.size.y 

	if top_left_y + tooltip_size.y > get_viewport_size().size.y:
		return null
	if top_left_x < 0:
		top_left_x = 0
	if top_left_x + tooltip_size.x >= get_viewport_size().size.x:
		top_left_x = get_viewport_size().size.x - tooltip_size.x

	return Vector2(top_left_x, top_left_y)

func get_viewport_size():
	# When editing, the viewport size is the size of view that we edit the level in.
	# I use 1920x1080 instead because we hardcode that for our project and it looks correct.
	if Engine.is_editor_hint():
		return Rect2(Vector2(0, 0), Vector2(1920, 1080))
	return get_viewport().get_visible_rect()

func get_tooltip_size():
	if tooltip:
		return tooltip.size
	return Vector2(0.,0.)
