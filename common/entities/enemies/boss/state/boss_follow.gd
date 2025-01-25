extends BossState

func enter(_previous_state_path: String, _data := {}) -> void:
	enemy.animated_sprite.play("walk")
	if not enemy.rangebox.area_entered.is_connected(transition_to_idle):
		enemy.rangebox.area_entered.connect(transition_to_idle)
	

func physics_update(_delta: float) -> void:
	enemy.velocity = (enemy.player_position - enemy.position).normalized() * enemy.speed
	enemy.move_and_slide()

	if enemy.velocity.x < 0:
		if enemy.flip_animation:
			enemy.animated_sprite.flip_h = false
		else:
			enemy.animated_sprite.flip_h = true
	else:
		if enemy.flip_animation:
			enemy.animated_sprite.flip_h = true
		else:
			enemy.animated_sprite.flip_h = false
	
	enemy.current_bubble_drop_timer -= _delta
	if enemy.current_bubble_drop_timer <= 0:
		finished.emit(ATTACK_BUBBLE_DROP)

func transition_to_idle(area:Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		finished.emit(IDLE)

func exit() -> void:
	enemy.rangebox.area_entered.disconnect(transition_to_idle)
