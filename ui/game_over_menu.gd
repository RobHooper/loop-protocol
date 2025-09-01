extends Control

signal restart_game

#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept") and $Timer.time_left <= 0:
#		#print("Game over")
#		emit_signal("restart_game")
#		queue_free()
#	print($Timer.time_left) # TODO Hide continue until timer is complete
#
#func _show():
#	show()
#	$Timer.start(2)
#
