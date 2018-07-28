tool
extends Node2D

export var extents = Vector2()

func is_colliding(obj):
    return get_rect().intersects(obj.get_rect())

func get_rect():
    return Rect2(position.x - extents.x, position.y - extents.y,
                 extents.x * 2, extents.y * 2)

func _process(delta):
    update()