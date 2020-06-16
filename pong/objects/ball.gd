extends KinematicBody2D

const MOVE_SPEED = 100

var initial_position : Vector2
var direction : Vector2

func reset():
    position = initial_position

func play():
    randomize()
    var dir = -1 if randi() % 2 == 0 else 1
    direction = Vector2(dir, rand_range(-1, 1)).normalized()

func _ready():
    initial_position = position

func _physics_process(delta):
    var velocity = direction * MOVE_SPEED * delta
    var collision = move_and_collide(velocity)
    if not collision:
        return

    var collider = collision.collider
    if not collider.has_method('is_in_group'):
        return

    if collider.is_in_group('paddle'):
        direction = collider.get_bounce_direction(position)
    else:
        direction = direction.bounce(collision.normal).normalized()
