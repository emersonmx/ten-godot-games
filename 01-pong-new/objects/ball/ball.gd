extends KinematicBody2D

signal squashed

var min_speed = 100
var max_speed = 1000
var speed_step = 5
var speed
var velocity = Vector2()

var _initial_position = Vector2()
var _initial_min_speed = min_speed

onready var up_area = $up_area
onready var down_area = $down_area

func _ready():
    randomize()
    _initial_position = position
    reset()
    play()

func reset():
    min_speed = _initial_min_speed
    position = _initial_position
    velocity = Vector2()
    speed = min_speed

func play():
    var timer := $play_delay
    timer.start()
    yield(timer, "timeout")

    #var direction = -1 if randi() % 2 == 0 else 1
    #velocity = Vector2(direction, rand_range(-1, 1))
    velocity = Vector2(-1, 0.75)

func _physics_process(delta):
    var collision := move_and_collide(velocity.normalized() * speed * delta)
    if collision:
        var collider := collision.collider
        if collider.is_in_group('Player'):
            var direction = collider.get_bounce_direction(self)
            velocity = velocity.direction_to(direction)
            if _is_squashed():
                emit_signal('squashed', self, _get_squashers())
            if collider.strong_hit:
                speed = max(collider.speed * collider.hit_force, speed)
            else:
                decreate_speed_by(speed * collider.damp_force)
        else:
            velocity = velocity.bounce(collision.normal.normalized())
            decreate_speed_by(speed_step * delta)

    min_speed = min(min_speed + speed_step * delta, max_speed)
    decreate_speed_by(speed_step * delta)

func decreate_speed_by(value):
    speed = clamp(speed - value, min_speed, max_speed)

func _is_squashed():
    return (!up_area.get_overlapping_bodies().empty()
        and !down_area.get_overlapping_bodies().empty())

func _get_squashers():
    if not _is_squashed():
        return []

    return up_area.get_overlapping_bodies() + down_area.get_overlapping_bodies()