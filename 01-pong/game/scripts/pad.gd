extends Area2D

const WALL_HEIGHT = 16
const MAX_SPEED = 300

enum Player {
	LEFT, RIGHT
}

export(int, 'Left', 'Right') var player = Player.LEFT
export(String) var move_up_action
export(String) var move_down_action

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	self._move_pad(delta)
	self._clamp_position()

func _move_pad(delta):
	var velocity = Vector2()
	if Input.is_action_pressed(move_up_action):
		velocity.y = -MAX_SPEED
	if Input.is_action_pressed(move_down_action):
		velocity.y = MAX_SPEED
	translate(velocity * delta)

func _clamp_position():
	var view_size = get_viewport_rect().size
	var pos = get_pos()
	var size = self._get_extents()
	pos.y = clamp(pos.y, size.y + WALL_HEIGHT,
		view_size.y - size.y - WALL_HEIGHT)
	set_pos(pos)

func get_anchor():
	var extents = self._get_extents()
	var point = Vector2(self._calc_height(extents.y * 2), get_pos().y)
	if player == Player.LEFT:
		point.x += extents.x
		point.x = -point.x
	else:
		point.x += extents.x + get_viewport_rect().size.x
	print(point)
	return point

func _calc_height(base, angle=30):
	return (base / 2.0) * tan(deg2rad(angle))

func _get_extents():
	return get_node('shape').get_shape().get_extents()
