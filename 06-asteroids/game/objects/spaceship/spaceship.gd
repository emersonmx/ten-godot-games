extends Area2D

export var rotation_speed = 2.6
export var thrust = 500
export var max_velocity = 400
export var friction = 0.65

var rotation = PI/2
var velocity = Vector2()
var acceleration = Vector2()

onready var screen_size = get_viewport_rect().size
onready var position = screen_size / 2

func _ready():
	set_pos(position)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed('left'):
		rotation += rotation_speed * delta
	if Input.is_action_pressed('right'):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed('thrust'):
		acceleration = Vector2(thrust, 0).rotated(rotation)
	else:
		acceleration = Vector2()

	acceleration += velocity * -friction
	velocity += acceleration * delta
	position += velocity * delta

	if position.x < 0:
		position.x = screen_size.width
	if position.x > screen_size.width:
		position.x = 0
	if position.y < 0:
		position.y = screen_size.height
	if position.y > screen_size.height:
		position.y = 0

	set_pos(position)
	set_rot(rotation - PI/2)