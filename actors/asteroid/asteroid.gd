extends Node2D

@export_range(20, 120)
var speed := 70.0
@export_range(-2.0, 2.0)
var spin_speed := 0.5  # Radians per second
var direction := Vector2.ZERO

const Actors = preload("res://scripts/actors.gd")

@export var explosion_scene: PackedScene

var parent = get_parent()

@export var points = 100

signal asteroid_destroyed(points)

func _ready() -> void:
	randomize()
	var angle = randf_range(0, TAU)  # TAU = 2 * PI
	direction = Vector2.RIGHT.rotated(angle)

	var fade_tween = create_tween()

	# Start fully transparent
	modulate.a = 0.0
	# Fade to fully opaque over 0.5 seconds
	fade_tween.tween_property(self, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	#connect("area_entered", _on_area_entered)

func _on_timer_timeout():
	self.collision_mask = (1 << 0) | (1 << 1) | (1 << 2)
	#$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	rotation += spin_speed * delta

	# Wrap around screen edges (screen size must be passed or hardcoded)
	var screen_size = get_viewport_rect().size
	position = Actors.wrap_position(position, screen_size)


func _on_area_entered(area):
	#print("Bullet")
	#print("Collided with:", area.name)
	#print("Groups:", area.get_groups())
	if area.is_in_group("Mobs"):
		if area.is_in_group("Mobs") and self.get_instance_id() < area.get_instance_id():
			# Prevent merge being called twice by both objects.
			merge(area)
	else:
		# Probably a bullet, they don't have a group..
		emit_signal("asteroid_destroyed", int(points * scale.x))  # Emit with score value
		if area.id == "bullet":
			explode(area, "green")
		elif area.id == "rocket":
			explode(area, "default", true)


func _on_body_entered(area: Node2D) -> void:
	#print("Player")
	#print("Collided with:", area.name)
	#print("Groups:", area.get_groups())
	if area.name == "Player":
		area.take_damage(points * scale.x)


func merge(area):
	# Two asteroids have clashed, Grow
	if scale <= Vector2(5,5):
		scale *= Vector2(1.5,1.5) # TODO Reduce value, or reduce exponentially. 1.5 is a good max.
	area.queue_free()

func explode(area, type = "default", keep_alive = false):
	# Trigger explosion
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.anim_to_play = type
	get_tree().current_scene.add_child(explosion)

	# Optionally: queue_free() if asteroid disappears
	if keep_alive == false:
		area.queue_free()
	queue_free()
