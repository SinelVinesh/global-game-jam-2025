extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		%PressAButton.hide()
		$StartGameSound.play()
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://levels/main_level/main_level.tscn")


func _on_button_hover() -> void:
	$HoverSound.play()

func _on_button_clicked() -> void:
	$SelectSound.play()
