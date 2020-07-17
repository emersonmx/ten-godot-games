extends Position2D

export (PackedScene) var object_scene
export (NodePath) var parent_path = '..'


func spawn():
	var object = object_scene.instance()
	object.position = global_position
	get_node(parent_path).add_child(object)
	return object
