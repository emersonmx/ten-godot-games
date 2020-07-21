extends Node2D

signal left_player_score_updated
signal right_player_score_updated

var left_player_score = 0 setget left_player_score_set
var right_player_score = 0 setget right_player_score_set


func left_player_score_set(value):
	left_player_score = value
	emit_signal('left_player_score_updated', left_player_score)


func right_player_score_set(value):
	right_player_score = value
	emit_signal('right_player_score_updated', right_player_score)


func _ready():
	var play_timer = $play_timer
	play_timer.start()
	yield(play_timer, 'timeout')
	spawn_ball()


func spawn_ball():
	var ball = $ball_spawn.spawn()
	ball.connect('squashed', self, '_on_ball_squashed')
	ball.reset()
	ball.play()


func _input(event):
	if Input.is_key_pressed(KEY_R) and event.is_pressed():
		spawn_ball()


func _on_ball_squashed(top_collider, bottom_collider):
	var squashed_timer = $squashed_timer
	if not squashed_timer.is_stopped():
		return

	var dir = 1 if top_collider.position.y - bottom_collider.position.y > 0 else -1
	var paddle = top_collider if top_collider.is_in_group('paddle') else bottom_collider
	paddle.direction.y = dir
	paddle.stunned = true

	squashed_timer.stop()
	squashed_timer.start()
	yield(squashed_timer, 'timeout')

	paddle.stunned = false
	paddle.direction = Vector2.ZERO


func _on_play_area_body_exited(body):
	if not body.is_in_group('ball'):
		return

	var exit_direction = (body.position - position).normalized().x
	if exit_direction > 0:
		left_player_score += 1
		$interface.update_player1_score(left_player_score)
	elif exit_direction < 0:
		right_player_score += 1
		$interface.update_player2_score(right_player_score)

	var play_timer = $play_timer
	play_timer.start()
	yield(play_timer, 'timeout')
	spawn_ball()


func _on_alive_area_body_exited(body):
	if not body.is_in_group('ball'):
		return

	body.queue_free()
