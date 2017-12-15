extends Node

export (PackedScene) var default_asteroid

onready var explosion_scene = preload('res://objects/explosion/explosion.tscn')
onready var spawns = get_node('spawn_locations')
onready var asteroids = get_node('asteroids')
onready var spaceship = get_node('spaceship')
onready var gameover_label = get_node('gameover')

func _ready():
	spaceship.connect('explode', self, '_on_spaceship_explode')
	spawn_asteroids()
	set_process(true)

func spawn_asteroids():
	for i in range(spawns.get_child_count()):
		spawn_asteroid(default_asteroid,
			spawns.get_child(i).get_pos(),
			Vector2(0, 0))

func _process(delta):
	if (asteroids.get_child_count() == 0):
		spawn_asteroids()

func spawn_asteroid(asteroid_scene, position, velocity):
	var asteroid = asteroid_scene.instance()
	asteroids.add_child(asteroid)
	asteroid.set_pos(position)
	asteroid.connect('explode', self, '_on_asteroid_explode')

func _on_spaceship_explode():
	_show_explosion(spaceship.get_pos())
	gameover_label.show()

func _on_asteroid_explode(pieces, position, velocity, hit_velocity):
	if pieces.size() == 0:
		return

	randomize()
	for offset in [-1, 1]:
		var new_position = position + hit_velocity.tangent().clamped(25) * offset
		var new_velocity = (velocity + hit_velocity.tangent() * offset) * 0.9
		var piece = pieces[rand_range(0, pieces.size())]
		spawn_asteroid(piece, new_position, new_velocity)

	_show_explosion(position)

func _show_explosion(position):
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.set_pos(position)
	explosion.play()