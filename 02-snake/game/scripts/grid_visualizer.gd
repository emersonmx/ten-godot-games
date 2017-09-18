extends Node2D

export(Color) var line_color = Color(255, 255, 255)
export(int) var line_width = 2

onready var grid = get_parent()

func _ready():
	set_opacity(0.2)

func _draw():
	var screen_size = get_viewport_rect().size

	for x in range(grid.grid_size.x + 1):
		var col_pos = x * grid.tile_size.x
		var limit = min(screen_size.y, grid.grid_size.x * grid.tile_size.x)
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), line_color, line_width)
	for y in range(grid.grid_size.y + 1):
		var row_pos = y * grid.tile_size.y
		var limit = min(screen_size.x, grid.grid_size.y * grid.tile_size.y)
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), line_color, line_width)
