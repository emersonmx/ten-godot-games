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
	for i in range(grid_size.x):
		grid.append([])
		for j in range(grid_size.y):
			grid[i].append(null)

func _create_snake():
	var snake = snake_scene.instance()
	snake.direction = snake.RIGHT
	snake.set_pos(map_to_world(grid_size / 2) + half_tile_size)
	add_child(snake)

func is_cell_vacant(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < 0 or grid_pos.x >= grid_size.x:
		return false
	if grid_pos.y < 0 or grid_pos.y >= grid_size.y:
		return false

	return grid[grid_pos.x][grid_pos.y] == null

func get_cell_object(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	return grid[grid_pos.x][grid_pos.y]

func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.get_pos())
	grid[grid_pos.x][grid_pos.y] = null

	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type

	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos
