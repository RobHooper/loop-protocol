extends ParallaxBackground

@export var BACKGROUND_SPEED := 0
var bg_target_index = 0
var bg_current_index = 0

@onready var current_bg = $ParallaxLayer/Background
@onready var next_bg = $ParallaxLayer/BackgroundNext
#@onready var tween = $Tween

#func _process(delta):
#	# TODO add white speed lines based on player speed.
#	
#	if Globals.score > 2000:
#		bg_target_index = 4 ## FIXME Won't do anything, index is 0-3 
#	elif Globals.score > 900:
#		bg_target_index = 3
#	elif Globals.score > 300:
#		bg_target_index = 2
#	elif Globals.score > 100:
#		bg_target_index = 1
#
#	if bg_target_index != bg_current_index:
#		fade_to_background(bg_target_index)


#var background_textures = [
#	preload("res://assets/images/backgrounds/bg1.png"),
#	preload("res://assets/images/backgrounds/bg2.png"),
#	preload("res://assets/images/backgrounds/bg3.png"),
#	preload("res://assets/images/backgrounds/bg4.png")
#]
#
#
#func fade_to_background(new_index: int):
#	if new_index < 0 or new_index >= background_textures.size():
#		return
#	
#	print("Change BG!, current:")
#	print(bg_current_index)
#
#	bg_current_index = new_index
#	
#	next_bg.texture = background_textures[new_index]
#	next_bg.modulate.a = 0.0
#	next_bg.visible = true
#
#	print("New!:")
#	print(bg_current_index)
#	
#	var fade_tween = create_tween()
#	fade_tween.kill()  # kill any active tweens
#	fade_tween.tween_property(next_bg, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
#	fade_tween.tween_callback(Callable(self, "_on_fade_complete"))
#	fade_tween.play()
#
#func _on_fade_complete():
#	current_bg.texture = next_bg.texture
#	next_bg.visible = false
#	next_bg.modulate.a = 0.0
#
