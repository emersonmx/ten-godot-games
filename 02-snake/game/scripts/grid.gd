extends TileMap

enum ObjectType {
	PLAYER, COLLECTIBLE
}

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var grid_size = Vector2(20, 20)
var grid = []

onready var snake_object = preload('res://objects/snake.tscn')
onready var food_object = preload('res://objects/food.tscn')

func _ready():
	_create_grid()
	_create_snake()
	_create_food()

func _draw_ascii_grid():
	print('---')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			printraw('#' if grid[y][x] == PLAYER else '.')
		print('')

func _create_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

func _create_snake():
	var snake = snake_object.instance()
	add_child(snake)

func _create_food():
	randomize()
	var cells = get_empty_cells()
	var random_cell = cells[randi() % cells.size()]
	var food = food_object.instance()
	food.set_pos(map_to_world(random_cell) + half_tile_size)
	add_child(food)

func get_cell_content(pos):
	return grid[pos.x][pos.y]

func set_cell_content(pos, type):
	grid[pos.x][pos.y] = type

func get_empty_cells():
	var result = []
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[y][x] == null:
				result.append(Vector2(x, y))
	return result
