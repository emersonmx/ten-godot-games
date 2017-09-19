extends Sprite

enum Direction {
	UP, RIGHT, DOWN, LEFT
}

var index
var snake

func _ready():
	snake = get_parent()
	set_fixed_process(true)

func _fixed_process(delta):
	pass

func _get_left_part():
	var left = index - 1
	if left < 0:
		return null
	return snake.parts[left]

func _get_right_part():
	var right = index + 1
	if right >= snake.parts.size():
		return null
	return snake.parts[right]
