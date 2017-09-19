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
