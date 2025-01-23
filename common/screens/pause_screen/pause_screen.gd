extends CanvasLayer

signal resume_game
signal quit_game

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	
	if Input.is_action_just_released("pause_game"):
		var paused = get_tree().paused
		get_tree().paused = !paused
		if paused:
			hide()
		else:
			show()

func _on_resume_button_button_down() -> void:
	get_tree().paused = false
	hide()


func _on_quit_button_pressed() -> void:
	_on_button_clicked()
	quit_game.emit()


func _on_button_hover() -> void:
	$HoverSound.play()

func _on_button_clicked() -> void:
	$SelectSound.play()
