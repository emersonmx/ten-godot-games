extends Node

var launcher_scene = preload('res://objects/launcher/launcher.tscn')
var explosion_scene = preload('res://objects/explosion/explosion.tscn')

onready var positions = get_node('positions')
onready var launchers = get_node('launchers')

func _get_launcher_position():
	var children = positions.get_children()
	var position = children[rand_range(0, children.size())]
	return position.get_pos()

func _ready():
	randomize()
	set_process_input(true)

func _input(event):
	if event.type != InputEvent.MOUSE_BUTTON: return
	if not event.is_pressed(): return

	if event.button_index == BUTTON_LEFT:
		var launcher = launcher_scene.instance()
		launchers.add_child(launcher)
		launcher.target.set_pos(event.pos)
		launcher.missile.set_pos(_get_launcher_position())
		launcher.connect('missile_exploded', self, '_on_explosion')

func _on_explosion(position):
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.set_pos(position)