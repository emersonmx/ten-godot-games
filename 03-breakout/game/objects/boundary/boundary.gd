extends StaticBody2D

onready var area_node = get_node('area')
onready var ball_scene = preload('res://objects/ball/ball.tscn')

func _ready():
	add_to_group('update_ball_speed')
	area_node.connect('body_exit', self, '_body_exit')

func _body_exit(body):
	if not body.is_in_group('ball'):
		return

	body.queue_free()
	var ball = ball_scene.instance()
	ball.set_pos(Vector2(128, 221))
	add_child(ball)