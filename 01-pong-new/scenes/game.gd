extends Node2D

func _ready():
    $area.connect("body_exited", self, 'reset')
    $ball.connect('squashed', $player_1, 'unsquash')
    $ball.connect('squashed', $player_2, 'unsquash')

func _unhandled_key_input(event):
    if event.is_pressed() and event.scancode == KEY_R:
        $ball.reset()
        $ball.play()

func reset(body):
    if not body.is_in_group('Ball'):
        return

    var timer = $reset_ball_timer
    timer.start()
    yield(timer, 'timeout')

    body.reset()
    body.play()