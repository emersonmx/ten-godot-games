extends Node2D

var ball_class = preload('res://objects/ball.tscn')

func _ready():
	get_node('area').connect('area_exit', self, '_on_out_of_area')
	create_ball()

func create_ball():
	var ball = ball_class.instance()
	ball.randomize_direction()
	add_child(ball)
	var screen_size = get_viewport_rect().size
	ball.set_pos(screen_size / 2)

func _on_out_of_area(body):
	if !body.is_in_group('ball'):
		return
	body.queue_free()
	create_ball()
