extends RigidBody2D

var _max_speed = 500
var _min_speed = 100
var _speed_step = 10
var _slow_step = 20

func _ready():
	var velocity = get_linear_velocity()
	_min_speed = velocity.length()

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
	print(velocity.length())

func _change_direction(direction):
	var velocity = get_linear_velocity()
	set_linear_velocity(velocity.rotated(velocity.angle_to(direction)))

func _body_enter(body):
	if body.is_in_group('pad'):
		_change_direction(get_pos() - body.get_anchor())

	if body.is_in_group('speed_update'):
		_speed_update()