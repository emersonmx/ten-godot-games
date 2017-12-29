extends Area2D

func _ready():
	var shape = CircleShape2D.new()
	get_node('shape').set_shape(shape)
	add_to_group('explosion')
