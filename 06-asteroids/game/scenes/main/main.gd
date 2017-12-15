extends Node

export (PackedScene) var default_asteroid

onready var spawns = get_node('spawn_locations')

func _ready():
	for i in range(spawns.get_child_count()):
		spawn_asteroid(default_asteroid,
			spawns.get_child(i).get_pos(),
			Vector2(0, 0))

func spawn_asteroid(asteroid_scene, position, velocity):
	var asteroid = asteroid_scene.instance()
	add_child(asteroid)
	asteroid.set_pos(position)
	asteroid.connect('explode', self, '_on_asteroid_explode')

func _on_asteroid_explode(pieces, position, velocity, hit_velocity):
	if pieces.size() == 0:
		return

	randomize()
	for offset in [-1, 1]:
		var new_position = position + hit_velocity.tangent().clamped(25) * offset
		var new_velocity = (velocity + hit_velocity.tangent() * offset) * 0.9
		var piece = pieces[rand_range(0, pieces.size())]
		spawn_asteroid(piece, new_position, new_velocity)