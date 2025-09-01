extends Area2D

@export var speed = 200
@export var ttl = 4

@export var id = "rocket"

const Actors = preload("res://scripts/actors.gd")

#@export var explosion_scene: PackedScene = preload("res://actors/bullet/Explosion.tscn")

func _ready():
	# Wait for 2 seconds then delete the bullet
	#connect("area_entered", _on_area_entered)
	await get_tree().create_timer(ttl).timeout
	# TODO: Disappear animation?
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta
	
	# Wrap if needed
	var screen_size = get_viewport_rect().size
	position = Actors.wrap_position(position, screen_size)
