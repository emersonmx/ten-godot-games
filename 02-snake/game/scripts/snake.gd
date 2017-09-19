extends Sprite

const SIZE = 4

const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

var direction = RIGHT
var type
var target_pos = Vector2()
var parts = []

var _delay = 0.2
var _delay_count = 0

var _part_scene = preload('res://objects/snake_part.tscn')

onready var grid = get_parent()

func _ready():
	type = grid.PLAYER
	_create_parts()
	set_fixed_process(true)

func _fixed_process(delta):
	_move(delta)

func _create_parts():
	var origin = grid.map_to_world(grid.grid_size / 2) + grid.half_tile_size
	var part
	for i in range(SIZE):
		part = _part_scene.instance()
		part.set_pos(origin + Vector2((i - SIZE) * grid.tile_size.x, 0))
		add_child(part)
		parts.push_front(part)

func _move(delta):
	if Input.is_action_pressed('up'):
		direction = UP
	elif Input.is_action_pressed('right'):
		direction = RIGHT
	elif Input.is_action_pressed('down'):
		direction = DOWN
	elif Input.is_action_pressed('left'):
		direction = LEFT

	_delay_count += delta
	if _delay_count < _delay:
		return
	_delay_count = 0

	if !_is_inside_of_grid():
		return
	if !_can_move():
		return

	_update_body()

func _is_inside_of_grid():
	var grid_pos = grid.world_to_map(_get_head().get_pos()) + direction
	if grid_pos.x < 0 or grid_pos.x >= grid.grid_size.x:
		return false
	if grid_pos.y < 0 or grid_pos.y >= grid.grid_size.y:
		return false
	return true

func _can_move():
	var pos = grid.world_to_map(_get_head().get_pos()) + direction
	return grid.get_cell_content(pos) == null

func _get_move_position():
	var grid_pos = grid.world_to_map(_get_head().get_pos())
	var new_grid_pos = grid_pos + direction
	grid.set_cell_content(grid_pos, null)
	grid.set_cell_content(new_grid_pos, type)
	return grid.map_to_world(new_grid_pos) + grid.half_tile_size

func _update_body():
	var part
	var move_position = _get_move_position()
	var last_position
	for i in range(parts.size()):
		part = parts[i]
		last_position = part.get_pos()
		part.set_pos(move_position)
		grid.set_cell_content(grid.world_to_map(move_position), grid.PLAYER)
		move_position = last_position

	grid.set_cell_content(grid.world_to_map(last_position), null)

func _get_head():
	return parts[0]
