extends KinematicBody2D

signal squashed

export(int) var min_speed = 100
export(int) var max_speed = 1000
export(int) var speed_step = 10
export(int) var fast_mode_max_speed = 300
export(int) var fast_mode_speed_damp = 60

var initial_position : Vector2
var direction : Vector2
var speed = 0
var is_in_fast_mode = false setget is_in_fast_mode_set
var fast_mode_speed = 0

func is_in_fast_mode_set(value):
    fast_mode_speed = fast_mode_max_speed
    is_in_fast_mode = value

func is_squashed():
    return $top_sensor.get_overlapping_bodies() and $bottom_sensor.get_overlapping_bodies()

func reset():
    position = initial_position
    speed = min_speed
    is_in_fast_mode = false
    fast_mode_speed = 0

func play():
    randomize()
    var dir = -1 if randi() % 2 == 0 else 1
    direction = Vector2(dir, rand_range(-1, 1)).normalized()

func _ready():
    initial_position = position

func _physics_process(delta):
    var current_speed = speed + fast_mode_speed
    current_speed = clamp(current_speed, min_speed, max_speed)
    var velocity = direction * current_speed * delta
    var collision = move_and_collide(velocity)
    if not collision:
        return

    var collider = collision.collider
    if not collider.has_method('is_in_group'):
        return

    if collider.is_in_group('paddle'):
        collider.hit_ball(self)
    else:
        direction = direction.bounce(collision.normal).normalized()

    if is_squashed():
        var top_collider = $top_sensor.get_overlapping_bodies().front()
        var bottom_collider = $bottom_sensor.get_overlapping_bodies().front()
        emit_signal('squashed', top_collider, bottom_collider)

    speed += speed_step
    speed = int(clamp(speed, min_speed, max_speed))

    fast_mode_speed -= fast_mode_speed_damp
    if fast_mode_speed <= 0:
        fast_mode_speed = 0
        is_in_fast_mode = false
