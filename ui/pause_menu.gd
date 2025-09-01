extends Control

signal unpause_game

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept") and not event.is_echo():
		print("unpause_game Signalled")
		emit_signal("unpause_game")
		hide()
