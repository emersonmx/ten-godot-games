extends Node2D

var score1 = 0
var score2 = 0

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

func _update_scores():
	get_node('scores/score1').set_text(str(score1))
	get_node('scores/score2').set_text(str(score2))

func _on_out_of_area(body):
	if !body.is_in_group('ball'):
		return

	if (body.get_pos() - get_viewport_rect().size / 2).x < 0:
		score1 += 1
	else:
		score2 += 1

	_update_scores()

	body.queue_free()
	create_ball()
