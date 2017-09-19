extends TileMap

enum ObjectType {
	PLAYER, FOOD
}

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var grid_size = Vector2(20, 20)
var grid = []

var _snake
var _food

onready var snake_object = preload('res://objects/snake.tscn')
onready var food_object = preload('res://objects/food.tscn')

func _ready():
	_clear_grid()
	_snake = _create_snake()
	_food = _create_food()

func _draw_ascii_grid():
	print('---')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			printraw('#' if grid[y][x] == PLAYER else '.')
		print('')

func _clear_grid():
	grid = []
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

func _create_snake():
	var snake = snake_object.instance()
	add_child(snake)
	snake.connect('dead', self, '_on_snake_dead')
	snake.connect('eat', self, '_on_snake_eat')
	return snake

func _create_food():
	randomize()
	var cells = get_empty_cells()
	var random_cell = cells[randi() % cells.size()]
	var food = food_object.instance()
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

func _on_snake_dead():
	print('dead')
