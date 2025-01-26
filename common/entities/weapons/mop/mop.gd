class_name Mop extends Weapon

var current_target: EnemyInRange


func _attack() -> void:
	if _enemies_in_range.size() > 0:
		current_target = get_nearest_untargeted_enemy(self, current_target)
		if current_target == null:
			return
		var enemy_position = current_target.enemy.global_position
		var direction = _player.global_position.direction_to(enemy_position)
		var rotation = direction.angle_to(Vector2.UP)
		self.rotation -= PI/2 + rotation
		$AnimationPlayer.play("Attack")
		await $AnimationPlayer.animation_finished
		_delay += 1
		self.rotation = 0
	_active = false
