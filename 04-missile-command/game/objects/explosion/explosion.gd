extends Area2D

onready var shape = get_node('shape')

export (float) var radius setget set_radius, get_radius

var colors = [
	Color('#ffffff'),
	Color('#797979'),
	Color('#e35100'),
	Color('#ffa200'),
	Color('#ebd320')
]

func set_radius(new_radius):
	radius = new_radius
	if shape and shape.get_shape():
		shape.get_shape().set_radius(new_radius)
		update()

func get_radius():
	return radius

func _ready():
	randomize()
	add_to_group('explosion')

	var shape = CircleShape2D.new()
	get_node('shape').set_shape(shape)
	get_node('animation').connect('finished', self, '_on_animation_finished')

func _draw():
	var color = colors[rand_range(0, colors.size())]
	draw_circle(shape.get_pos(), radius, color)

func _on_animation_finished():
	queue_free()