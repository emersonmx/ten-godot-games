extends Node

onready var missile = get_node('missile')
onready var target = get_node('target')
onready var timer = get_node('timer')

func _ready():
	missile.target = target

	target.connect('body_enter', self, '_on_body_enter')

func _on_body_enter(body):
	if body != missile:
		return

	missile.explode()
	timer.set_wait_time(missile.smoke.get_lifetime())
	timer.connect('timeout', self, '_on_timer_timeout')
	timer.start()

func _on_timer_timeout():
	print('done')
	queue_free()