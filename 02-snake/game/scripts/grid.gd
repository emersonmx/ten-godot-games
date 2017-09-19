extends TileMap

enum ObjectType {
	PLAYER, COLLECTIBLE
}

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var grid_size = Vector2(20, 20)
var grid = []

onready var snake_scene = preload('res://objects/snake.tscn')

func _ready():
	_create_grid()
	_create_snake()

func _create_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

func _create_snake():
	var snake = snake_scene.instance()
	add_child(snake)

func get_cell_content(pos):
	return grid[pos.x][pos.y]

func set_cell_content(pos, type):
	grid[pos.x][pos.y] = type
