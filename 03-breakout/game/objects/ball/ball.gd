extends RigidBody2D

var max_speed = 500
var _hit_paddle = false
var _hit_direction = Vector2()

func _ready():
	self.connect('body_enter', self, '_body_enter')
	set_fixed_process(true)

func _fixed_process(delta):
	var velocity = get_linear_velocity()
	var speed = velocity.length()
	if _hit_paddle:
		_hit_paddle = false
		velocity = velocity.rotated(velocity.angle_to(_hit_direction))
	velocity = velocity.clamped(max_speed)
	set_linear_velocity(velocity)

func _body_enter(body):
	if not body.is_in_group('pad'):
		return

	_hit_direction = get_pos() - body.get_anchor()
	_hit_paddle = true