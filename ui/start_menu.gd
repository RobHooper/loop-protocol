extends Control

signal start_game

func _process(_delta):
	#print(visible)
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel") and visible:
		print("Start Game Signalled")
		emit_signal("start_game")
		hide()
