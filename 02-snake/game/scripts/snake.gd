extends Area2D

const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

var direction = Vector2()
var speed = 50
var max_speed = 200

var type

var is_moving = false
var target_pos = Vector2()
var target_direction = Vector2()

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

	if not is_moving and direction != Vector2():
		target_direction = direction.normalized()
		if grid.is_cell_vacant(get_pos(), direction):
			target_pos = grid.update_child_pos(self)
			is_moving = true
	elif is_moving:
		var pos = get_pos()
		var velocity = target_direction * speed * delta

		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = velocity.length()
		if move_distance > distance_to_target:
			velocity = target_direction * distance_to_target
			is_moving = false

		set_pos(pos + velocity)
