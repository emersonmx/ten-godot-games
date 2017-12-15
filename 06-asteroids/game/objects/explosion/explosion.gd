extends AnimatedSprite

func _ready():
	self.connect('finished', self, '_on_finished')

func _on_finished():
	queue_free()