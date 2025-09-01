extends Node2D

@onready var name_input = $EnterName/NameInput
#@onready var submit_button = $SubmitButton
@onready var high_score_list = $HighScore/List

var disable_restart := true

func _ready():
	$EnterName.show()
	name_input.grab_focus()
	refresh_scores()

var BACKGROUND_SPEED = 5
func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x += BACKGROUND_SPEED*delta
	$ParallaxBackground.scroll_offset.y += BACKGROUND_SPEED*delta


func _on_submit_pressed(name: String):
	name = name_input.text.to_upper()
	var score = Globals.score
	Globals.add_score(name, score)	
	refresh_scores()
	$EnterName.hide()
	$HighScore/LastScore.text = "Last Score: {name} - {score}".format({"name": name, "score": score})
	disable_restart = false

func refresh_scores():
	# Clear old list
	for child in high_score_list.get_children():
		child.queue_free()

	# Show top 10
	for entry in Globals.high_scores:
		var label = Label.new()
		label.text = "%s - %d" % [entry["name"], entry["score"]]
		high_score_list.add_child(label)

func _unhandled_input(event):
	#print("Input!")
	if disable_restart:
		return
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept") and event.pressed:
			get_tree().change_scene_to_file("res://scenes/level_01.tscn")
