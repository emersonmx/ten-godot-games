extends Node

const SIZE = 4

const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

signal dead
signal eat

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

	set_process_input(true)
	set_process(true)

func _create_parts():
	var origin = grid.map_to_world(grid.grid_size / 2) + grid.half_tile_size
	var part
	for i in range(SIZE):
		part = _part_scene.instance()
		part.set_pos(origin + Vector2((i - SIZE) * grid.tile_size.x, 0))
		part.index = (SIZE - 1) - i
		add_child(part)
		grid.set_cell_content(grid.world_to_map(part.get_pos()), grid.PLAYER)
		parts.push_front(part)

func _input(event):
	if event.is_action_pressed('up'):
		if direction == DOWN:
			return
		direction = UP
	elif event.is_action_pressed('right'):
		if direction == LEFT:
			return
		direction = RIGHT
	elif event.is_action_pressed('down'):
		if direction == UP:
			return
		direction = DOWN
	elif event.is_action_pressed('left'):
		if direction == RIGHT:
			return
		direction = LEFT

func _process(delta):
	_delay_count += delta
	if _delay_count < _delay:
		return
	_delay_count = 0

	_move(delta)

func _move(delta):
	if !_is_inside_of_grid():
		emit_signal('dead')
		return

	if !_can_move():
		emit_signal('dead')
		return

	var emit_eat_signal = false
	if _can_eat():
		_grow()
		emit_eat_signal = true

	_update_body()

	if emit_eat_signal:
		emit_signal('eat')

func _is_inside_of_grid():
	var grid_pos = grid.world_to_map(_get_head().get_pos()) + direction
	if grid_pos.x < 0 or grid_pos.x >= grid.grid_size.x:
		return false
	if grid_pos.y < 0 or grid_pos.y >= grid.grid_size.y:
		return false
	return true

func _can_move():
	var pos = grid.world_to_map(_get_head().get_pos()) + direction
	return grid.get_cell_content(pos) != grid.PLAYER

func _can_eat():
	var pos = grid.world_to_map(_get_head().get_pos()) + direction
	return grid.get_cell_content(pos) == grid.FOOD

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

func _get_tail():
	return parts[-1]

func _grow():
	var tail = _get_tail()
	var part = tail.duplicate()
	part.index = tail.index + 1
	add_child(part)
	grid.set_cell_content(grid.world_to_map(part.get_pos()), grid.PLAYER)
	parts.push_back(part)
