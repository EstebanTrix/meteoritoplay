extends Node2D

@export var mob_scene: PackedScene

var score: int = 0
var meteors_destroyed: int = 0
var game_running: bool = false


func _ready():
	if has_node("Player"):
		if not $Player.health_changed.is_connected(_on_player_health_changed):
			$Player.health_changed.connect(_on_player_health_changed)


func new_game():
	score = 0
	meteors_destroyed = 0
	game_running = true

	# Eliminar meteoritos que hayan quedado de una partida anterior
	for child in get_children():
		if child.is_in_group("mobs"):
			child.queue_free()

	# Iniciar al jugador
	$Player.start($StartPosition.position)

	# Actualizar los datos del HUD
	if has_node("HUD"):
		$HUD.update_score(score)
		$HUD.update_lives($Player.health)
		$HUD.update_meteors_destroyed(meteors_destroyed)

	# Comenzar el juego inmediatamente
	$MobTimer.start()
	$ScoreTimer.start()


func game_over():
	if not game_running:
		return

	game_running = false

	# Detener meteoritos y puntaje
	$MobTimer.stop()
	$ScoreTimer.stop()

	# Ocultar la nave
	$Player.disable()

	# Mostrar Game Over
	if has_node("HUD"):
		$HUD.show_game_over()


func _on_player_health_changed(current_health: int):
	if has_node("HUD"):
		$HUD.update_lives(current_health)

	# Game Over solamente cuando llega a 0 vidas
	if current_health <= 0:
		game_over()


func add_meteor_destroyed():
	if not game_running:
		return

	meteors_destroyed += 1

	print("Meteoritos destruidos: ", meteors_destroyed)

	if has_node("HUD"):
		$HUD.update_meteors_destroyed(meteors_destroyed)


func _on_mob_timer_timeout():
	if not game_running:
		return

	if mob_scene == null:
		return

	var mob = mob_scene.instantiate()

	var screen_width = get_viewport_rect().size.x
	var random_x = randf_range(50.0, screen_width - 50.0)

	mob.position = Vector2(random_x, -60)

	add_child(mob)


func _on_score_timer_timeout():
	if not game_running:
		return

	score += 1

	if has_node("HUD"):
		$HUD.update_score(score)


func _on_start_timer_timeout():
	# Ya no usamos este Timer para iniciar la partida.
	pass


func _on_hud_start_game():
	new_game()
