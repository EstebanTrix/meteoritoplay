extends Area2D

signal hit
signal health_changed(current_health)

@export var speed: int = 400
@export var bullet_scene: PackedScene
var screen_size: Vector2
@export var max_health: int = 3
var health: int = max_health
var can_shoot: bool = true


func _ready():
	screen_size = get_viewport_rect().size
	health = max_health

	# Configuración de colisiones
	# Player está en Layer 1
	collision_layer = 1

	# Player detecta meteoritos que están en Layer 4
	collision_mask = 4

	monitoring = true
	monitorable = true

	hide()


func _process(delta):
	var velocity = Vector2.ZERO

	# Movimiento
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	# Mantener la nave dentro de la pantalla
	position.x = clamp(position.x, 20.0, screen_size.x - 20.0)
	position.y = clamp(position.y, 20.0, screen_size.y - 20.0)

	# Disparar con ESPACIO
	if Input.is_action_just_pressed("ui_select") and can_shoot:
		shoot()


func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()

		bullet.position = position + Vector2(0, -35)

		get_tree().current_scene.add_child(bullet)


func start(pos):
	position = pos
	show()

	health = max_health
	can_shoot = true

	set_process(true)

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", false)

	health_changed.emit(health)


func take_damage():
	if health <= 0:
		return

	health -= 1

	print("Jugador golpeado. Vidas restantes: ", health)

	health_changed.emit(health)
	hit.emit()

	if health <= 0:
		disable()


func disable():
	set_process(false)
	can_shoot = false
	hide()

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)


func enable():
	set_process(true)
	can_shoot = true
	show()

	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = false


func _on_area_entered(area):
	if area.is_in_group("mobs"):
		print("Meteorito golpeó al jugador")

		take_damage()

		# El meteorito desaparece después de golpear
		area.queue_free()
