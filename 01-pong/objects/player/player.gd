extends 'res://scripts/collision.gd'

var WALL_HEIGHT = 8

export var speed = 300

onready var screen_size = get_viewport_rect().size
onready var anchor = $anchor

func _ready():
    pass

func _physics_process(delta):
    var velocity = _input_velocity()
    position += velocity.normalized() * speed * delta
    position.y = clamp(position.y, WALL_HEIGHT + extents.y,
                       screen_size.y - WALL_HEIGHT - extents.y)

func _input_velocity():
    var velocity = Vector2()
    if Input.is_action_pressed(name + '_up'):
        velocity = Vector2(0, -1)
    if Input.is_action_pressed(name + '_down'):
        velocity = Vector2(0, 1)
    return velocity
