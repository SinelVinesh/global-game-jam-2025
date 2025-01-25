class_name EnemyIdle extends EnemyState

func enter(_previous_state_path: String, _data := {}) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite.play("idle")
	enemy.rangebox.area_exited.connect(transition_to_follow)

func transition_to_follow(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		finished.emit(FOLLOW)
	
