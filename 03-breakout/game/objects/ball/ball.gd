extends RigidBody2D

var _max_speed = 500
var _min_speed = 100
var _speed_increment = 10
var _speed_decrement = 20

func _ready():
	_clamp_speed(_min_speed)

	self.connect('body_enter', self, '_body_enter')
	set_fixed_process(true)

func _fixed_process(delta):
	_clamp_speed(_max_speed)

func _clamp_speed(speed):
	var velocity = get_linear_velocity()
	set_linear_velocity(velocity.clamped(speed))

func _speed_update():
	_clamp_speed(_max_speed)

	var velocity = get_linear_velocity()
	var speed = velocity.length()
	if speed > _min_speed:
		_clamp_speed(max(speed - _speed_decrement, _min_speed))

	#_min_speed += _speed_increment
	print(get_linear_velocity().length())

func _change_direction(direction):
	var velocity = get_linear_velocity()
	set_linear_velocity(velocity.rotated(velocity.angle_to(direction)))

func _body_enter(body):
	if body.is_in_group('pad'):
		_change_direction(get_pos() - body.get_anchor())

	if body.is_in_group('speed_update'):
		_speed_update()