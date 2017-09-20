extends Sprite

enum Direction {
	UP, RIGHT, DOWN, LEFT, MID, UP_RIGHT, RIGHT_DOWN, DOWN_LEFT, LEFT_UP, BLANK
}

enum SpriteFrame {
}

var index
var snake

func _ready():
	snake = get_parent()
	set_fixed_process(true)

func _fixed_process(delta):
	var sprite = BLANK
	if _is_head():
		sprite = _get_head_direction()
	elif _is_tail():
		sprite = _get_tail_direction()
	elif _is_mid():
		sprite = MID

	set_frame(sprite)

func _is_head():
	return index == 0

func _is_tail():
	return index == (snake.parts.size() - 1)

func _get_head_direction():
	var part = _get_right_part()
	var p1 = get_pos()
	var p2 = part.get_pos()
	if p1.x < p2.x:
		return LEFT
	if p1.x > p2.x:
		return RIGHT
	if p1.y < p2.y:
		return UP
	if p1.y > p2.y:
		return DOWN

func _get_tail_direction():
	var part = _get_left_part()
	var p1 = get_pos()
	var p2 = part.get_pos()
	if p1.x < p2.x:
		return LEFT
	if p1.x > p2.x:
		return RIGHT
	if p1.y < p2.y:
		return UP
	if p1.y > p2.y:
		return DOWN

func _is_mid():
	var left = _get_left_part()
	var right = _get_right_part()
	var left_pos = left.get_pos()
	var right_pos = right.get_pos()
	var pos = get_pos()
	if left_pos.x < pos.x < pos.x < right_pos.x:
		return true
	if left_pos.x > pos.x > pos.x > right_pos.x:
		return true
	return false

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
