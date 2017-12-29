extends KinematicBody2D

signal exploded

export (float) var speed = 2

var target = null
var velocity = Vector2()

onready var smoke = get_node('smoke')

func _get_target_pos():
	return target.get_pos()

func _ready():
	add_to_group('missile')
	set_fixed_process(true)

func _fixed_process(delta):
	var position = get_pos()
	velocity += (_get_target_pos() - position).normalized()
	move(velocity * speed * delta)
	set_rot(velocity.angle() - PI)

func explode(position):
	set_fixed_process(false)
	smoke.set_emitting(false)
	get_node('sprite').queue_free()
	get_node('shape').queue_free()
	emit_signal('exploded', position)