extends Node2D


@export var speed_int = 10


func _physics_process(delta): 
	var dir_int = Vector2()

	if Input.is_action_pressed("ui_up"):
		dir_int.y = -1

	if Input.is_action_pressed("ui_down"):
		dir_int.y = 1

	if Input.is_action_pressed("ui_right"):
		dir_int.x = 1

	if Input.is_action_pressed("ui_left"):
		dir_int.x = -1

	position += dir_int * speed_int

	if dir_int == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("default")

	if dir_int.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func shoot(): add_child(load("res://Bullet.tscn").instantiate())


func spawn(): get_parent().add_child(load("res://Enemy.tscn").instantiate())


func restart_game():
	get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("Die")
	$DeathAnimationPlayer.play("Death")
