extends Node

var explosion_scene = preload('res://objects/explosion/explosion.tscn')

onready var missile = get_node('missile')
onready var target = get_node('target')

func _ready():
	missile.target = target
	target.connect('body_enter', self, '_on_body_enter')

func _on_body_enter(body):
	if body != missile:
		return

	missile.explode()

	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.set_pos(target.get_pos())
	explosion.get_node('animation').connect('finished', self, '_on_explosion_finished')

func _on_explosion_finished():
	queue_free()