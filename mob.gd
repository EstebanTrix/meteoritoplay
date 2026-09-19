extends Area2D

@export var speed: float = 200.0


func _ready():
	# Meteorito = Layer 4
	collision_layer = 4

	# Detecta balas = Layer 2
	collision_mask = 2

	monitoring = true
	monitorable = true


func _process(delta):
	position.y += speed * delta


func _on_area_entered(area):
	if area.is_in_group("bullets"):
		print("Meteorito destruido por una bala")

		var main = get_tree().current_scene

		if main.has_method("add_meteor_destroyed"):
			main.add_meteor_destroyed()

		area.queue_free()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
