extends TileMap

enum ObjectType {
	PLAYER, FOOD
}

export(bool) var show_ascii_grid = false

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var grid_size = Vector2(20, 20)
var grid = []

var _snake
var _food

onready var game_over_node = get_node('/root/game/game_over')
onready var timer_node = get_node('/root/game/timer')
onready var snake_object = preload('res://objects/snake.tscn')
onready var food_object = preload('res://objects/food.tscn')

func _ready():
	_start_game()
	timer_node.connect('timeout', self, '_on_timeout')

	set_process(show_ascii_grid)

func _start_game():
	for o in get_tree().get_nodes_in_group('game'):
		o.queue_free()
	_clear_grid()
	_snake = _create_snake()
	_food = _create_food()

func _process(delta):
	_draw_ascii_grid()

func _draw_ascii_grid():
	var t = ''
	t+='---\n'
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[y][x] == PLAYER:
				t+='#'
			elif grid[y][x] == FOOD:
				t+='@'
			else:
				t+='.'
		t+='\n'
	print(t)

func _clear_grid():
	grid = []
	for y in range(grid_size.y):
		grid.append([])
		for x in range(grid_size.x):
			grid[y].append(null)

func _create_snake():
	var snake = snake_object.instance()
	add_child(snake)
	snake.connect('dead', self, '_on_snake_dead')
	snake.connect('eat', self, '_on_snake_eat')
	return snake

func _create_food():
	randomize()
	var cells
	var random_cell
	var food
	while true:
		cells = get_empty_cells()
		if cells.empty():
			return null
		random_cell = cells[randi() % cells.size()]
		if get_cell_content(random_cell) != null:
			continue

		food = food_object.instance()
		food.set_pos(map_to_world(random_cell) + half_tile_size)
		add_child(food)
		set_cell_content(random_cell, FOOD)

		return food

func get_cell_content(pos):
	return grid[pos.x][pos.y]

func set_cell_content(pos, type):
	grid[pos.x][pos.y] = type

func get_empty_cells():
	var result = []
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			if grid[y][x] == null:
				result.append(Vector2(x, y))
	return result

func _on_snake_eat():
	set_cell_content(world_to_map(_food.get_pos()), null)
	_food.queue_free()
	_food = _create_food()
	if _food == null:
		_show_game_over()

func _on_snake_dead():
	_show_game_over()

func _show_game_over():
	game_over_node.show()
	get_tree().set_pause(true)
	timer_node.start()

func _on_timeout():
	game_over_node.hide()
	get_tree().set_pause(false)
	_start_game()
