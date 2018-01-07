extends Node

var explosion_scene = preload('res://objects/explosion/explosion.tscn')
var missile_scene = preload('res://objects/missile/missile.tscn')
var target_scene = preload('res://objects/target/target.tscn')

onready var launchers = get_node('launchers')

func _create_target():
	var object = target_scene.instance()
	add_child(object)
	return object

func _create_missile():
	var object = missile_scene.instance()
	add_child(object)
	object.connect('exploded', self, '_on_explosion')
	return object

func _launch_missile(from, to):
	var target = _create_target()
	target.set_pos(to)

	var missile = _create_missile()
	missile.set_pos(from)
	missile.target = target.get_global_pos()

	target.connect('body_enter', self, '_on_missile_reach_target', [target, missile])

func _ready():
	randomize()
	set_process_input(true)

func _input(event):
	if event.type != InputEvent.MOUSE_BUTTON: return
	if not event.is_pressed(): return

	if event.button_index == BUTTON_LEFT:
		var launcher_list = launchers.get_children()
		var launcher = launcher_list[rand_range(0, launcher_list.size())]
		_launch_missile(launcher.get_node('canon').get_global_pos(), event.pos)

func _on_missile_reach_target(body, target, missile):
	if body != missile:
		return

	missile.explode(target.get_pos())

	var timer = Timer.new()
	timer.set_one_shot(true)
	var seconds = missile.smoke.get_lifetime()
	timer.set_wait_time(seconds if seconds > 0 else 1)
	add_child(timer)
	timer.start()

	yield(timer, 'timeout')
	missile.queue_free()
	target.queue_free()
	timer.queue_free()

func _on_explosion(position):
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.set_pos(position)