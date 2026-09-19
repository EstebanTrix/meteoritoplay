extends CanvasLayer

signal start_game


func _ready():
	# Al comenzar, ocultar los datos del juego
	if has_node("ScoreLabel"):
		$ScoreLabel.hide()

	if has_node("HeartsContainer"):
		$HeartsContainer.hide()

	if has_node("MeteorsLabel"):
		$MeteorsLabel.hide()


func show_message(text: String):
	if has_node("MessageLabel"):
		$MessageLabel.text = text
		$MessageLabel.show()


func hide_message():
	if has_node("MessageLabel"):
		$MessageLabel.hide()


func show_game_over():
	# Mostrar los datos finales
	if has_node("ScoreLabel"):
		$ScoreLabel.show()

	if has_node("MeteorsLabel"):
		$MeteorsLabel.show()

	if has_node("HeartsContainer"):
		$HeartsContainer.hide()

	# Mostrar mensaje de Game Over
	show_message("GAME OVER")

	# Mostrar botón para volver a iniciar
	if has_node("StartButton"):
		await get_tree().create_timer(1.0).timeout
		$StartButton.show()


func start_game_ui():
	# Mostrar los datos cuando comienza la partida
	if has_node("ScoreLabel"):
		$ScoreLabel.show()

	if has_node("HeartsContainer"):
		$HeartsContainer.show()

	if has_node("MeteorsLabel"):
		$MeteorsLabel.show()

	# Ocultar botón de iniciar
	if has_node("StartButton"):
		$StartButton.hide()

	# Ocultar mensaje inicial
	hide_message()


func update_score(score: int):
	if has_node("ScoreLabel"):
		$ScoreLabel.text = "PUNTAJE: " + str(score)


func update_lives(lives: int):
	if has_node("HeartsContainer"):
		# Eliminar corazones anteriores
		for child in $HeartsContainer.get_children():
			child.queue_free()

		# Crear los corazones correspondientes a las vidas
		for i in range(lives):
			var heart_label = Label.new()

			heart_label.text = "♥"

			heart_label.add_theme_font_size_override(
				"font_size",
				28
			)

			heart_label.add_theme_color_override(
				"font_color",
				Color(1.0, 0.2, 0.3)
			)

			$HeartsContainer.add_child(heart_label)


func update_meteors_destroyed(count: int):
	if has_node("MeteorsLabel"):
		$MeteorsLabel.text = "METEORITOS ELIMINADOS: " + str(count)


func _on_start_button_pressed():
	start_game_ui()
	start_game.emit()


func _on_message_timer_timeout():
	if has_node("MessageLabel"):
		$MessageLabel.hide()
