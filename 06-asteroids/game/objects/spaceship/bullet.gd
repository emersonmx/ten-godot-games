extends Area2D

export var speed = 1000

var velocity = Vector2()

onready var lifetime_node = get_node('lifetime')
onready var screen_size = get_viewport_rect().size

func _ready():
	lifetime_node.connect('timeout', self, '_on_lifetime_timeout')

	set_fixed_process(true)

func start_at(direction, position, velocity):
	set_rot(direction)
	set_pos(position)
	self.velocity = velocity + Vector2(speed, 0).rotated(direction + PI/2)

func _fixed_process(delta):
	var position = get_pos()
	if position.x < 0:
		position.x = screen_size.width
	if position.x > screen_size.width:
		position.x = 0
	if position.y < 0:
		position.y = screen_size.height
	if position.y > screen_size.height:
		position.y = 0

	set_pos(position + velocity * delta)

func _on_lifetime_timeout():
	queue_free()