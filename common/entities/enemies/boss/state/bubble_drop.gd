extends BossState

var bubbles_destination: Array
var offset = 300

func enter(_previous_state_path: String, _data := {}) -> void:
	# Calculate the positions the bubble will appear
	# We will spwan 5 bubbles
	var loaded_bubble = load("res://common/entities/enemies/boss/boss_bullet/boss_bullet.tscn")
	bubbles_destination = [
		enemy.player_position, 
		enemy.player_position + Vector2.UP * offset,
		enemy.player_position + Vector2.RIGHT * offset,
		enemy.player_position + Vector2.DOWN * offset,
		enemy.player_position + Vector2.LEFT * offset,
		]
	for i in range(5):
		var bubble = loaded_bubble.instantiate() 
		get_parent().add_child(bubble)
		bubble.position = enemy.global_position
		bubble.set_destination(bubbles_destination[i], (i+1)* 0.5,true)
	enemy.current_bubble_drop_timer = enemy.bubble_drop_timer
	finished.emit(FOLLOW)
