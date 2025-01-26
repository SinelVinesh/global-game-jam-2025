extends BossState

func enter(_previous_state_path: String, _data := {}) -> void:
	# Calculate the positions the bubble will appear
	# We will spwan 5 bubbles
	var loaded_bubble = load("res://common/entities/enemies/boss/boss_bullet/boss_bullet.tscn")
	for i in range(5):
		var initial_bubble_pos = enemy.player_position + (enemy.global_position - enemy.player_position).normalized() * 100
		initial_bubble_pos = initial_bubble_pos - enemy.player_position
		var bubble = loaded_bubble.instantiate() 
		get_parent().add_child(bubble)
		bubble.position = enemy.global_position
		bubble.init_bullet(enemy.damage, initial_bubble_pos.rotated(i*0.3*(-1**i)) + enemy.player_position, i* 0.2, false)
	enemy.current_bubble_barrage_timer = enemy.bubble_barrage_timer
	finished.emit(IDLE)
