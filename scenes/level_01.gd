extends Node2D

@export var asteroid_scene: PackedScene
@export var powerup_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(0, 0, 1024, 768) # Adjust to your map size
#var spawn_area = get_viewport_rect().size ## FIXME 

var severity = 0

@onready var player = $Player
@onready var ui_health_bar = $UI/PlayerHealthBar
@onready var ui_score = $UI/Score

@onready var parallax_bg = $ParallaxBackground
var player_velocity = Vector2.ZERO
var bg_scroll_velocity := Vector2.ZERO

var next_powerup_score := 350

func _ready():
	get_tree().paused = true
	player.health_changed.connect(_update_health)
	player.player_died.connect(_game_over)

func _process(delta):
	# Use negative velocity to make background move opposite to player
	if player:
		player_velocity = player.velocity  # Replace with your actual player velocity
	else:
		player_velocity = Vector2.ZERO
	#parallax_bg.scroll_offset += -player_velocity * delta * 0.3  # 0.5 is scroll sensitivity
	
	var target_scroll = -player_velocity * 0.5
	bg_scroll_velocity = bg_scroll_velocity.lerp(target_scroll, 5 * delta)
	parallax_bg.scroll_offset += bg_scroll_velocity * delta

	$UI/Reload/ColorRect/ReloadPercentage.value = $ReloadTimer.time_left / $ReloadTimer.wait_time * $UI/Reload/ColorRect/ReloadPercentage.max_value



func _update_health(new_health):
	#print(player.max_health)
	ui_health_bar.value = float(new_health) / player.max_health * 100
	print(new_health)

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = get_random_position_in_spawn_area()
	asteroid.connect("asteroid_destroyed", Callable(self, "_on_asteroid_destroyed"))
	add_child(asteroid)

func spawn_powerup():
	var powerup = powerup_scene.instantiate()
	powerup.global_position = get_random_position_in_spawn_area()
	powerup.connect("collected", Callable(self, "_on_power_up_collected"))
	powerup.connect("collected", Callable($Player, "_on_power_up_collected"))
	add_child(powerup)

func get_random_position_in_spawn_area() -> Vector2:
	var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	return Vector2(x, y)

func _on_timer_timeout():
	severity += 0.5
	## TODO: Tiers of severity ??
	for i in floor(severity):
		spawn_asteroid()

#func _reload_timer_set(time):
#	$ReloadTimer.start(time)

func _on_reload_timer_timeout():
	$UI/Reload/ColorRect/ReloadPercentage.hide()
	$UI/Reload/ColorRect/ActionName.show()

func _on_asteroid_destroyed(points: Variant) -> void:
	Globals.score += points
	ui_score.text = "Score: %s" % Globals.score
	
	if Globals.score >= next_powerup_score:
		spawn_powerup()
		next_powerup_score += 1000

func _game_over():
	#print("game over!")
	$GameOver.show()
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_power_up_collected(_id: Variant) -> void:
	print("Level got called")


func _on_player_new_ability(value: String, value2: String) -> void:
	$UI/Reload/ColorRect/ActionName.text = "L.O.O.P. MODE: %s" % value
	$UI/Reload/ColorRect/ActionNext.text = "NEXT: %s" % value2


func _on_player_reloading(time) -> void:
	$ReloadTimer.start(time)
	$UI/Reload/ColorRect/ReloadPercentage.show()
