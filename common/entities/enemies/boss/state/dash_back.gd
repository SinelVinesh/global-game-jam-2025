extends BossState

var dash_destination: Vector2
var dash_speed = 1000
var active_dash = false

func enter(_previous_state_path: String, _data := {}) -> void:
	# Calculate the destination of the dash
	dash_destination = enemy.global_position + (enemy.global_position - enemy.player_position).normalized() * 1500
	enemy.speed = dash_speed
	active_dash = true
	
func physics_update(_delta: float) -> void:
	if active_dash:
		if enemy.global_position.distance_to(dash_destination) > 10:
			enemy.velocity = (dash_destination - enemy.global_position).normalized() * enemy.speed
			enemy.move_and_slide()
		else:
			enemy.velocity = Vector2.ZERO
			active_dash = false
			enemy.current_dash_back_timer = enemy.dash_back_timer
			finished.emit(ATTACK_BUBBLE_DROP)
			enemy.speed = enemy.initial_boss_speed
