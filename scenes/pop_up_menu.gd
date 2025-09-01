extends CanvasLayer

var state = "start"

var pause_message := """
[b]L.O.O.P. Protocol Suspended[/b]

Weapon cycling on stand-by. Adapt or be destroyed.

[i]Press SPACE to continue.[/i]
"""

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		
		# Start Menu
		if state == "start" and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel")):
			#print("Start Game")
			state = "game_active"
			hide()
			get_tree().paused = false
			$RichTextLabel.text = pause_message
		elif state == "game_active" and event.is_action_pressed("ui_cancel"):
			#print("Pause")
			get_tree().paused = true
			show()
			state = "paused"
		elif state == "paused"  and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel")):
			#print("Unpause")
			hide()
			state = "game_active"
			get_tree().paused = false
