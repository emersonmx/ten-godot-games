tool
extends KinematicBody2D

enum Player {
    ONE = 1,
    TWO,
}
export(Player) var player_index = Player.ONE setget player_index_set
export(String) var up_action_name
export(String) var down_action_name
export(int) var move_speed = 300

var up_pressed = 0
var down_pressed = 0
var direction = Vector2.ZERO

func player_index_set(value):
    player_index = value
    var hit_base = $hit_base
    if not hit_base:
        return
    var pos_x = abs(hit_base.position.x)
    if value == Player.ONE:
        pos_x = -pos_x
    if value == Player.TWO:
        pos_x = pos_x
    hit_base.position.x = pos_x

func get_bounce_direction(hit_point : Vector2) -> Vector2:
    return (hit_point - $hit_base.global_position).normalized()

func _ready():
    pass

func _input(event):
    if event.is_action_pressed(up_action_name):
        up_pressed = 1
    if event.is_action_released(up_action_name):
        up_pressed = 0
    if event.is_action_pressed(down_action_name):
        down_pressed = 1
    if event.is_action_released(down_action_name):
        down_pressed = 0

    direction.y = down_pressed - up_pressed

func _physics_process(delta):
    var velocity = direction * move_speed * delta
    var collision = move_and_collide(velocity)
    if not collision:
        return
    var collider = collision.collider
    if not collider.has_method('is_in_group'):
        return
    if not collider.is_in_group('ball'):
        return

    hit_ball(collider)

func hit_ball(ball):
    ball.direction = get_bounce_direction(ball.position)
    if up_pressed > 0 or down_pressed > 0:
        ball.is_in_fast_mode = true
