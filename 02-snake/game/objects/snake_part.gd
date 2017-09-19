extends Sprite

enum Direction {
	UP, RIGHT, DOWN, LEFT
}

var direction = RIGHT
var previous = null
var next = null

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	pass
