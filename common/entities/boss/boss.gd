extends "res://common/entities/enemy/enemy.gd" #Extends enemy.gd lmao


func _ready():
	player_position = get_parent().get_node("Player").global_position
	position = player_position + Vector2(1000, 0).rotated(randf_range(0, 2 * PI))
	velocity = (player_position - position).normalized() * speed

	health = max_health
	$Control_Enemy/TXProgressBar_Health.max_value = health
	_update_health_ui()


func _physics_process(delta):
	player_position = get_parent().get_node("Player").global_position
	velocity = (player_position - position).normalized() * speed
	move_and_slide()

	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("default")

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


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
