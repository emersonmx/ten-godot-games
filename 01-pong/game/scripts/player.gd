extends KinematicBody2D

const WALL_HEIGHT = 16
const MAX_SPEED = 300

func _ready():
	set_process(true)

func _process(delta):
	self._move_pad(delta)
	self._clamp_position()

func _move_pad(delta):
	var velocity = Vector2()
	if Input.is_action_pressed('move_up'):
		velocity.y = -MAX_SPEED
	if Input.is_action_pressed('move_down'):
		velocity.y = MAX_SPEED
	translate(velocity * delta)

func _clamp_position():
	var view_size = get_viewport_rect().size
	var pos = get_pos()
	var size = get_node('shape').get_shape().get_extents()
	pos.y = clamp(pos.y, size.y + WALL_HEIGHT,
		view_size.y - size.y - WALL_HEIGHT)
	set_pos(pos)
