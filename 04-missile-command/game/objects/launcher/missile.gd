extends KinematicBody2D

export (float) var speed = 2
var target = null
var velocity = Vector2()

onready var smoke = get_node('smoke')

func _get_target_pos():
	return target.get_pos()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if not target: return

	var position = get_pos()
	velocity += (_get_target_pos() - position).normalized()
	position += velocity * speed * delta
	set_rot(velocity.angle() - PI)
	set_pos(position)

func explode():
	smoke.set_emitting(false)
	get_node('sprite').hide()
	get_node('shape').hide()