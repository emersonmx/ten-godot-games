extends Area2D

signal ball_exited_on_the_left
signal ball_exited_on_the_right


func _on_body_exited(body):
	if not body.is_in_group('ball'):
		return

	var direction = (body.position - position).normalized().x
	if direction > 0:
		emit_signal('ball_exited_on_the_right')
	elif direction < 0:
		emit_signal('ball_exited_on_the_left')
