extends Area2D
# player.gd
#extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed = 400

#func _process(delta):
#	if !is_on_floor():
#		sprite.play("jump")
#	elif velocity.x != 0:
#		sprite.play("run")
#	else:
#		sprite.play("idle")

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("turn_right"):
		velocity.x += 1
	if Input.is_action_pressed("turn_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_backward"):
		velocity.y += 1
	if Input.is_action_pressed("move_forward"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
