extends Sprite

enum Direction {
	UP, RIGHT, DOWN, LEFT, MID, UP_RIGHT, RIGHT_DOWN, DOWN_LEFT, LEFT_UP, BLANK
}

var index
var snake

func _ready():
	snake = get_parent()
	set_process(true)

func _process(delta):
	update_frame()

func update_frame():
	var sprite = MID
	if is_head():
		sprite = get_head_direction()
	elif is_tail():
		sprite = get_tail_direction()
	elif is_mid():
		sprite = MID
	elif is_up_right():
		sprite = UP_RIGHT
	elif is_right_down():
		sprite = RIGHT_DOWN
	elif is_down_left():
		sprite = DOWN_LEFT
	elif is_left_up():
		sprite = LEFT_UP

	set_frame(sprite)

func is_head():
	return index == 0

func is_tail():
	return index == (snake.parts.size() - 1)

func get_head_direction():
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

func get_tail_direction():
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

func is_mid():
	var left = _get_left_part()
	var right = _get_right_part()
	var diff = (left.get_pos() - right.get_pos()).abs()
	if diff.x > 0 and diff.y == 0:
		return true
	if diff.x == 0 and diff.y > 0:
		return true
	return false

func is_up_right():
	var l = _get_left_part().get_pos()
	var r = _get_right_part().get_pos()
	var p = get_pos()
	if l.y < p.y and p.x < r.x:
		return true
	if r.y < p.y and p.x < l.x:
		return true
	return false

func is_right_down():
	var l = _get_left_part().get_pos()
	var r = _get_right_part().get_pos()
	var p = get_pos()
	if p.x < r.x and p.y < l.y:
		return true
	if p.x < l.x and p.y < r.y:
		return true
	return false

func is_down_left():
	var l = _get_left_part().get_pos()
	var r = _get_right_part().get_pos()
	var p = get_pos()
	if p.x > l.x and p.y < r.y:
		return true
	if p.x > r.x and p.y < l.y:
		return true
	return false

func is_left_up():
	var l = _get_left_part().get_pos()
	var r = _get_right_part().get_pos()
	var p = get_pos()
	if p.x > r.x and p.y > l.y:
		return true
	if p.x > l.x and p.y > r.y:
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
