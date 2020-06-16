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
