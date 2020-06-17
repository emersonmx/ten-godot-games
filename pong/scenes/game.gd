extends Node2D

func _ready():
    var play_timer = $play_timer
    play_timer.start()
    yield(play_timer, 'timeout')
    $ball.reset()
    $ball.play()

func _input(event):
    if Input.is_key_pressed(KEY_R) and event.is_pressed():
        $ball.reset()
        $ball.play()

func _on_ball_leaves_play_area(body):
    if not body.is_in_group('ball'):
        return

    var play_timer = $play_timer
    play_timer.start()
    yield(play_timer, 'timeout')
    $ball.reset()
    $ball.play()

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
