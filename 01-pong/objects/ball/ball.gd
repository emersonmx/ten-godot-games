extends 'res://scripts/collision.gd'

signal point

var velocity = Vector2()
var speed = 100
var speed_step = 10
var min_speed = 100
var max_speed = 1000

var top_wall
var bottom_wall
var player1
var player2
var game_area

func _ready():
    reset()

func _physics_process(delta):
    if is_colliding(top_wall) or is_colliding(bottom_wall):
        velocity.y = velocity.y * -1
    if is_colliding(player1):
        var direction = position - player1.anchor.global_position
        velocity = velocity.rotated(velocity.angle_to(direction))
    if is_colliding(player2):
        var direction = position - player2.anchor.global_position
        velocity = velocity.rotated(velocity.angle_to(direction))
    if is_colliding(player1) or is_colliding(player2):
        speed += speed_step
        speed = clamp(speed, min_speed, max_speed)
    if not get_rect().intersects(game_area):
        var from_who = 1 if (position - (game_area.size / 2)).x > 0 else 2
        emit_signal('point', from_who)
        reset()

    position += velocity.normalized() * speed * delta

func reset():
    position = game_area.size / 2
    speed = min_speed
    velocity = Vector2()

    var timer = $timer
    timer.start()
    yield(timer, 'timeout')

    randomize()
    velocity = Vector2(1, 0)
    velocity = velocity.rotated(rand_range(PI/4, -PI/4))
    velocity.x *= -1 if randi() % 2 == 0 else 1
