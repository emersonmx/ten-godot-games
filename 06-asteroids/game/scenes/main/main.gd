extends Node

export (PackedScene) var default_asteroid

onready var spawns = get_node('spawn_locations')

func _ready():
	for i in range(spawns.get_child_count()):
		var asteroid = default_asteroid.instance()
		add_child(asteroid)
		asteroid.set_pos(spawns.get_child(i).get_pos())
