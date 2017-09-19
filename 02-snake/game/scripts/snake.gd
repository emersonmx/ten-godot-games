extends Area2D

const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

var type
var direction = Vector2()
var target_pos = Vector2()

var _delay = 0.3
var _delay_count = 0

onready var grid = get_parent()

func _ready():
	type = grid.PLAYER
	set_fixed_process(true)

func _fixed_process(delta):
	_move(delta)

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
	if _delay_count >= _delay:
		if grid.is_cell_vacant(get_pos(), direction.normalized()):
			target_pos = grid.update_child_pos(self)
			set_pos(target_pos)
			_delay_count = 0
