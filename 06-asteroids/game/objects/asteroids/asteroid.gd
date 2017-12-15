extends KinematicBody2D

signal exploded

export var bounce = 1.1
export (Array) var pieces

var velocity = Vector2()
var rotation_speed
var acceleration = Vector2()

onready var screen_size = get_viewport_rect().size
onready var extents = get_node('sprite').get_texture().get_size() / 2
onready var puff = get_node('puff')

func _ready():
	randomize()
	velocity = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI))
	rotation_speed = rand_range(-1.5, 1.5)

	add_to_group('asteroids')

	set_fixed_process(true)

func _fixed_process(delta):
	set_rot(get_rot() + rotation_speed * delta)
	move(velocity * delta)
	if is_colliding():
		var collider = get_collider()
		velocity += get_collision_normal() * (collider.velocity.length() * bounce)
		puff.set_global_pos(get_collision_pos())
		puff.set_emitting(true)

	var position = get_pos()
	if position.x > screen_size.width + extents.width:
		position.x = -extents.width
	if position.x < -extents.width:
		position.x = screen_size.width + extents.width
	if position.y > screen_size.height + extents.height:
		position.y = -extents.height
	if position.y < -extents.height:
		position.y = screen_size.height + extents.height

	set_pos(position)

func explode(hit_velocity):
	emit_signal('exploded', pieces, get_pos(), velocity, hit_velocity)
	queue_free()