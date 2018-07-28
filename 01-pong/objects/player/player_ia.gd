extends 'player.gd'

export var vision = 300

var threshold = 10
var ball

func _input_velocity():
    var velocity = Vector2()
    var goto_position = ball.position
    if (ball.position - position).length() > vision:
        goto_position.y = screen_size.y / 2

    if position.y - threshold > goto_position.y:
        velocity = Vector2(0, -1)
    elif position.y + threshold < goto_position.y:
        velocity = Vector2(0, 1)
    return velocity