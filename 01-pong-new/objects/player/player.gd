tool
extends StaticBody2D

export(int, "Player 1", "Player 2") var type = 0 setget type_set
export(Vector2) var bounce_direction_offset = Vector2(20, 0) setget bounce_direction_offset_set
export var max_speed = 300
export var hit_force = 2
export var damp_force = 0.2
export(float) var min_y = 10
export(float) var max_y = 590

var velocity = Vector2()
var speed = max_speed
var strong_hit = false

func _ready():
    if Engine.editor_hint:
        update()

func _physics_process(delta):
    var extents = $collision.shape.extents
    var name = get_name()
    var input = int(Input.is_action_pressed(name + "_down")) - int(Input.is_action_pressed(name + "_up"))
    strong_hit = input != 0
    velocity.y = input
    position += velocity.normalized() * delta * speed
    position.y = clamp(position.y, min_y + extents.y, max_y - extents.y)

func get_bounce_direction(ball):
    var direction = ball.position - $bounce_direction.global_position
    return direction.normalized()

func get_name():
    return "player_%d" % (type + 1)

func type_set(value):
    type = value
    update_bounce_direction()

func bounce_direction_offset_set(value):
    bounce_direction_offset = value
    update_bounce_direction()

func update_bounce_direction():
    var side = -1 if type == 0 else 1
    $bounce_direction.position = Vector2(
        bounce_direction_offset.x * side,
        bounce_direction_offset.y
    )
    if Engine.editor_hint:
        update()