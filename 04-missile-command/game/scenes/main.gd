extends Node

var launcher_scene = preload('res://objects/launcher/launcher.tscn')

onready var launchers = get_node('launchers')
onready var targets = get_node('targets')

func _get_launcher_position():
	var children = launchers.get_node('positions').get_children()
	var position = children[rand_range(0, children.size())]
	return position.get_pos()

func _ready():
	randomize()
	set_process_input(true)

func _input(event):
	if event.type != InputEvent.MOUSE_BUTTON:
		return
	if event.is_pressed():
		var launcher = launcher_scene.instance()
		launchers.get_node('missiles').add_child(launcher)
		launcher.target.set_pos(event.pos)
		launcher.missile.set_pos(_get_launcher_position())