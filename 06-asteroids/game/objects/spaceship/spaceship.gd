extends Area2D

signal explode

export var rotation_speed = 2.6
export var thrust = 500
export var max_velocity = 400
export var friction = 0.65
export (PackedScene) var bullet_scene

var rotation = PI/2
var velocity = Vector2()
var acceleration = Vector2()

onready var screen_size = get_viewport_rect().size
onready var position = screen_size / 2
onready var bullets = get_node('bullets')
onready var gun_timer = get_node('gun_timer')

func _ready():
	set_pos(position)

	self.connect('body_enter', self, '_on_body_enter')

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
	if Input.is_action_pressed('shoot'):
		shoot()

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

func shoot():
	if gun_timer.get_time_left() != 0:
		return

	gun_timer.start()

	var muzzle = get_node('muzzle')
	var bullet = bullet_scene.instance()
	bullets.add_child(bullet)
	bullet.start_at(get_rot(), muzzle.get_global_pos(), velocity)

func disable():
	hide()
	set_process(false)

func _on_body_enter(body):
	if not body.is_in_group('asteroids'):
		return

	disable()
	emit_signal('explode')