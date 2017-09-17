extends Area2D

var _max_speed = 700
var _speedup_step = 20
var _speed = 100
var direction = Vector2()

func _ready():
	self.connect('area_enter', self, '_on_area_enter')
	set_process(true)

func _process(delta):
	var pos = get_pos()
	pos += direction.normalized() * _speed * delta
	set_pos(pos)

func _on_area_enter(body):
	if body.is_in_group('pad'):
		direction = get_pos() - body.get_anchor()
		speedup()
	if body.is_in_group('wall'):
		direction.y = -direction.y

func randomize_direction():
	randomize()
	var side = -1 if randi() % 2 == 0 else 1
	var angle = rand_range(-1, 1)
	direction = Vector2(side, angle)

func speedup():
	_speed += _speedup_step
	_speed = clamp(_speed, _speed, _max_speed)
