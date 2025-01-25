extends Node2D


@export var speed_int = 10
@export var max_health = 100
@export var i_frames = 5
@export var spawn_boss_time = 600

var health
var damage_taken := 0
var current_i_frames := 0

var is_hit = false

#Call when node enters main scene
func _ready() -> void:
	health = max_health
	%PlayerCamera/Control_Player/ProgressBar_Health.value = health
	_update_boss_timer()

	$Timer_SpawnBoss.set_wait_time(spawn_boss_time)
	$Timer_SB_Counter.start()

	$PlayerCamera/Control_Player/Label_SpawnBoss_Text.visible = false


#Called in real time
func _physics_process(delta): 
	var dir_int = Vector2()

	#Handle player movement input
	if Input.is_action_pressed("ui_up"):
		dir_int.y = -1
		
	if Input.is_action_pressed("ui_down"):
		dir_int.y = 1

	if Input.is_action_pressed("ui_right"):
		dir_int.x = 1

	if Input.is_action_pressed("ui_left"):
		dir_int.x = -1

	position += dir_int * speed_int

	#Handler player movement animation
	if dir_int == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("default")

	if dir_int.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif dir_int.x > 0:
		$AnimatedSprite2D.flip_h = false

	handleDamage()

	if is_hit:
		_hit_animation()


#Shoot bullet automatically
func shoot(): add_child(load("res://common/entities/bullet/bullet.tscn").instantiate())


#Spawn ennemies automatically
# func spawn(): get_parent().add_child(load("res://common/entities/enemies/common_bubble/common_bubble.tscn").instantiate())


#Restart game on player death
func restart_game():
	get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")


#Handle health
func _on_hurtbox_body_entered(body: Node2D) -> void:
	damage_taken += body.damage
	is_hit = true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Damaging"):
		damage_taken += area.damage
		is_hit = true


func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("Damaging"):
		damage_taken -= area.damage
		is_hit = false

func _on_hurtbox_body_exited(body: Node2D) -> void:
	damage_taken -= body.damage
	is_hit = false

# function which handle damage
func handleDamage() -> void :
	if current_i_frames == 0:
		health -= damage_taken
		_update_health_ui()
		if health <= 0:
			$DeathAnimationPlayer.play("Death")
		current_i_frames += i_frames
	else:
		current_i_frames -= 1


#Update health ui
func _update_health_ui():
	%PlayerCamera/Control_Player/ProgressBar_Health.value = health


#Do hit animation
func _hit_animation():
	$HitAnimationPlayer.play("Player_Hit")


#Spawn boss
func _on_timer_spawn_boss_timeout() -> void:
	print("Boss spawned")
	get_parent().add_child(load("res://common/entities/enemies/boss/boss.tscn").instantiate())


#Handle boss spawn counter
func _on_timer_sb_counter_timeout() -> void:
	pass # Replace with function body.
	if spawn_boss_time == 0:
		$Timer_SpawnBoss.start()
		$Timer_SB_Counter.stop()
		$PlayerCamera/Control_Player/Label_SpawnBoss_Text.visible = true
		await get_tree().create_timer(1.5).timeout
		$PlayerCamera/Control_Player/Label_SpawnBoss_Text.visible = false
	else:
		spawn_boss_time -= 1
		_update_boss_timer()


#Update boss timer
func _update_boss_timer():
	$PlayerCamera/Control_Player/Label_Timer_Boss.text = str(spawn_boss_time)
