extends KinematicBody2D

export var min_padding = 8
export var max_padding = 8

var speed = 200;
var padding = 20

func _ready():
	add_to_group('update_ball_speed')
	set_fixed_process(true)

func _fixed_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed('left'):
		direction.x = -1
	if Input.is_action_pressed('right'):
		direction.x = 1
	_move(direction * speed * delta)

func _move(rel_vec):
	var view_size = get_viewport_rect().size
	var pos = get_pos()
	var size = self._get_extents()
	pos += rel_vec
	pos.x = clamp(pos.x, size.x + min_padding,
		view_size.x - max_padding - size.x)
	set_pos(pos)

func get_anchor():
	var extents = self._get_extents()
	var offset = _calc_height(extents.x * 2)
	var point = get_pos()
	point.y = (point.y - extents.y) + offset
	return point

func _calc_height(base, angle=30):
	return (base / 2.0) * tan(deg2rad(angle))

func _get_extents():
	return get_node('shape').get_shape().get_extents()
