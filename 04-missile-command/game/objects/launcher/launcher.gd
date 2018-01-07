extends Node

const LOADED = 0
const EMPTY = 1

var target = null
var missile = null

onready var timer = get_node('timer')

func _ready():
	pass

func _on_timeout():
	queue_free()

func _on_missile_exploded(position):
	emit_signal('missile_exploded', position)