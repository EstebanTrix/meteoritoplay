extends Area2D

@export var speed: float = 700.0


func _ready():
	# Bala = Layer 2
	collision_layer = 2

	# Detecta meteoritos = Layer 4
	collision_mask = 4

	monitoring = true
	monitorable = true


func _process(delta):
	position.y -= speed * delta

	if position.y < -50:
		queue_free()
