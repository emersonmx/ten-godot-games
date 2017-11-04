extends RigidBody2D

var _max_speed = 400
var _min_speed = 100
var _speed_increment = 2
var _speed_decrement = 10

func _ready():
	_clamp_speed(_min_speed)

	add_to_group('ball')

	self.connect('body_enter', self, '_body_enter')
	set_fixed_process(true)

func _fixed_process(delta):
	_clamp_speed(_max_speed)

func _clamp_speed(speed):
	var velocity = get_linear_velocity()
	set_linear_velocity(velocity.clamped(speed))

func _update_speed():
	_clamp_speed(_max_speed)

	var velocity = get_linear_velocity()
	var speed = velocity.length()

	if speed > _min_speed:
		_clamp_speed(max(speed - _speed_decrement, _min_speed))
	else:
		velocity = velocity.normalized() * _min_speed
		set_linear_velocity(velocity)

	_min_speed += _speed_increment
	if _min_speed > _max_speed:
		_min_speed = _max_speed

	print(get_linear_velocity().length())

func _change_direction(direction):
	var velocity = get_linear_velocity()
	set_linear_velocity(velocity.rotated(velocity.angle_to(direction)))

func _body_enter(body):
	if body.is_in_group('block'):
		body.queue_free()

	if body.is_in_group('paddle'):
		_change_direction(get_pos() - body.get_anchor())

	if body.is_in_group('update_ball_speed'):
		_update_speed()