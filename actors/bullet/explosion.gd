extends AnimatedSprite2D

var anim_to_play: String = "default"

func _ready():
	play(anim_to_play)

func _on_animation_finished():
	queue_free()
