extends Area2D

#@export_range(20, 120)
#var speed := 70.0
#@export_range(-2.0, 2.0)
#var spin_speed := 0.5  # Radians per second
#var direction := Vector2.ZERO

var id = "bullet"
@onready var anim = $AnimatedSprite2D

var options = [
	"bullet",
	"shield",
	"rocket",
	"health",
	"triple",
	"rapidfire"
]

# Movement
var float_speed = 2.0      # oscillation speed
var float_range = 10.0     # how high/low to move
var base_y = 0.0           # original Y position
var time = 0.0             # animation time

signal collected(id)

func _ready() -> void:
	id = options.pick_random()
	anim.play(id)
	base_y = position.y

func _physics_process(delta):
	time += delta
	position.y = base_y + sin(time * float_speed) * float_range


func _on_body_entered(body: Node2D) -> void:
	print("Body entered!")
	print(body)
	collected.emit(id)
	queue_free()

#func _on_area_entered(body: Node2D) -> void:
#	print("Area entered!")
#	print(body)
#	print(body.id)
#	queue_free()
