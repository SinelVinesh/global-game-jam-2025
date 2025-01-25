class_name Boss extends Enemy


func _init():
	speed = 150
	damage = 10
	max_health = 300
	exp_point_min = 50
	exp_point_max = 150
	flip_animation = false


#Update health ui
func _update_health_ui():
	$Control_Enemy/TXProgressBar_Health.value = health


#Handle receive damage
func _receive_damage():
	health -= damage_taken
	_update_health_ui()
	if health <= 0:
		$AnimationPlayer.play("Death")
	else:
		$AnimationPlayer.play("Enemy_Hit")
