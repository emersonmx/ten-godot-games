extends RigidBody2D

var max_speed = 500

func _ready():
	self.connect('body_enter', self, '_body_enter')
	set_fixed_process(true)

func _fixed_process(delta):
	var velocity = get_linear_velocity()
	var speed = velocity.length()
	velocity = velocity.clamped(max_speed)
	set_linear_velocity(velocity)

func _body_enter(body):
	if not body.is_in_group('pad'):
		return

	var direction = get_pos() - body.get_anchor()
	print(direction)