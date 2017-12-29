extends Node

signal missile_exploded

onready var missile = get_node('missile')
onready var target = get_node('target')
onready var timer = get_node('timer')

func _ready():
	missile.target = target
	missile.connect('exploded', self, '_on_missile_exploded')
	target.connect('body_enter', self, '_on_missile_reach_target')
	timer.connect('timeout', self, '_on_timeout')

func _on_missile_reach_target(body):
	if body != missile:
		return

	missile.explode(target.get_pos())
	target.queue_free()

	timer.set_wait_time(missile.smoke.get_lifetime())
	timer.start()

func _on_timeout():
	queue_free()

func _on_missile_exploded(position):
	emit_signal('missile_exploded', position)