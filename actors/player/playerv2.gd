extends CharacterBody2D

@export var THRUST_FORCE := 200.0
@export var ROTATION_SPEED := 3.0  # Radians per second
const ROTATION_SPEED_BAK := 3.0
@export var MAX_SPEED := 300.0
@export var Bullet : PackedScene
@export var Rocket : PackedScene

@export var reloadtime:= 0.3
@onready var reload_timer = $ReloadTimer

@onready var anim = $AnimatedSprite2D
var banking = "idle"

const Actors = preload("res://scripts/actors.gd")
@export var explosion_scene: PackedScene = preload("res://actors/bullet/Explosion.tscn")

@export var max_health := 496
var health := max_health

signal player_died
signal health_changed(value)
signal new_ability(value, value2)
signal reloading(value)

var action_list: Array = [
	"bullet",
	"triple",
]
var current_action_index: int = 0
var can_use_ability = true

func _physics_process(delta: float) -> void:
	#print($ReloadTimer.time_left)
	#print(action_list)
	# Rotate ship
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		if anim.animation != "idle" and not anim.is_playing():
			anim.play("idle")
			banking = "idle"
	elif Input.is_action_pressed("ui_left"):
		rotation -= ROTATION_SPEED * delta
		if not banking == "left" and not anim.is_playing():
			anim.flip_h = false
			anim.play("bank")
			banking = "left"
	elif Input.is_action_pressed("ui_right"):
		rotation += ROTATION_SPEED * delta
		if not banking == "right" and not anim.is_playing():
			anim.flip_h = true
			anim.play("bank")
			banking = "right"
	else:
		if anim.animation != "idle" and not anim.is_playing():
			anim.play("idle")
			banking = "idle"

	# Apply thrust
	if Input.is_action_pressed("ui_up"):
		var thrust = Vector2.UP.rotated(rotation) * THRUST_FORCE * delta
		velocity += thrust
		$Exhaust.show()
		$Exhaust2.show()
	else:
		$Exhaust.hide()
		$Exhaust2.hide()

	#if Input.is_action_just_pressed("ui_accept"):
	if Input.is_action_pressed("ui_accept"):
		if reload_timer.time_left == 0 and can_use_ability:
			use_current_ability()
			#current_action_index = (current_action_index + 1) % action_list.size()
		else:
			pass
			#reloading.emit(reloadtime)

	# Clamp to max speed
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	# Move and apply velocity
	position += velocity * delta

	# Wrap around screen edges (screen size must be passed or hardcoded)
	var screen_size = get_viewport_rect().size
	position = Actors.wrap_position(position, screen_size) 

func bullet(offset = 0):
	var marker_home = $Marker2D.rotation
	$Marker2D.rotate(deg_to_rad(offset))
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.transform = $Marker2D.global_transform
	$Marker2D.rotation = marker_home

func rocket(offset = 0):
	var marker_home = $Marker2D.rotation
	$Marker2D.rotate(deg_to_rad(offset))
	var b = Rocket.instantiate()
	owner.add_child(b)
	b.transform = $Marker2D.global_transform
	$Marker2D.rotation = marker_home

func add_ability(new_ability: String):
	if new_ability == "shield":
			remove_next_ability()
	elif new_ability == "health":
		health += max_health * 0.2
		health_changed.emit(health )
	else:
	#if not action_list.has(new_ability):
		action_list.append(new_ability)
		print("New ability added:", new_ability)

func remove_next_ability():
	print("Removed Ability")
	action_list.remove_at((current_action_index + 1) % action_list.size())
	new_ability.emit(get_next_ability(), get_next_ability(1))

func get_next_ability(n: int = 0):
	#return action_list[(current_action_index + 1) % action_list.size()]
	return action_list[(current_action_index + n) % action_list.size()]

func use_current_ability():
	can_use_ability = false  # Block further uses
	var action = action_list[current_action_index % action_list.size()]
	var rtime = reloadtime
	#print(reload_timer.time_left)
	match action:
		"bullet":
			bullet()
		"triple":
			bullet()
			bullet(10)
			bullet(-10)
			rtime = reloadtime * 3
		"rapidfire":
			ROTATION_SPEED = ROTATION_SPEED_BAK * 0.3
			for i in range(0,25):
				await get_tree().create_timer(0.05).timeout
				bullet()
			rtime = reloadtime * 5
		#"health":
		#	health += max_health * 0.1
		#	health_changed.emit(health)
		#	rtime = reloadtime * 3
		"rocket":
			rocket()
			rtime = reloadtime * 2
		_:
			print("Unknown ability:", action)
	reload_timer.start(rtime)
	reloading.emit(rtime)
	can_use_ability = true
	ROTATION_SPEED = ROTATION_SPEED_BAK
	#
	#await reload_timer.timeout

	
	new_ability.emit(get_next_ability(), get_next_ability(1))

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)
	health_changed.emit(health)
	if health <= 0:
		death()
		player_died.emit()

func death():
	# Trigger explosion
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.scale = Vector2(3,3)
	get_tree().current_scene.add_child(explosion)
	queue_free()


func _on_power_up_collected(id: Variant) -> void:
	add_ability(id)


func _on_loop_timer_timeout() -> void:
	current_action_index = (current_action_index + 1) % action_list.size()
