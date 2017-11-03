extends StaticBody2D

onready var area_node = get_node('area')

func _ready():
	area_node.connect('body_exit', self, '_body_exit')

func _body_exit(body):
	if not body.is_in_group('ball'):
		return

	body.queue_free()
	print('Game Over!')