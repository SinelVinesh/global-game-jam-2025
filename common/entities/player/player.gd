class_name Player extends Node2D


@export var speed = 5.0
@export var max_health = 100
@export var i_frames = 5
@export var spawn_boss_time = 600

var health := 0
var damage_taken := 0
var current_i_frames := 0

var is_hit = false
var dash_is_reset = true

# weapon stats
# mop
var damages = Dictionary({
	Mop : 20,
	NailGun : 20
})
var delays = Dictionary({
	Mop : 1,
	NailGun : 1
})
var ranges = Dictionary({
	Mop : 1,
	NailGun : 1
})

#Call when node enters main scene
func _ready() -> void:
	health = max_health
	%PlayerCamera/Control_Player/ProgressBar_Health.value = health
	_update_boss_timer()

	$Timer_SpawnBoss.set_wait_time(spawn_boss_time)
	$Timer_SB_Counter.start()

	$PlayerCamera/Control_Player/Label_SpawnBoss_Text.visible = false

	# base weapon
	var mop = load("res://common/entities/weapons/mop/mop.tscn").instantiate()
	mop.init(damages[Mop], delays[Mop], ranges[Mop])
	$Weapons.add_child(mop)


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
	
	if Input.is_action_just_pressed("Dash") and dash_is_reset:
		dash_is_reset = false
		speed = 20
		await get_tree().create_timer(0.5).timeout
		speed = 10
		dash_is_reset = true

	position += dir_int * speed

	#Handler player movement animation
	if dir_int == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	else:
		if speed == 10:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("Dash")

	if dir_int.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif dir_int.x > 0:
		$AnimatedSprite2D.flip_h = false

	handleDamage()

	if is_hit:
		_hit_animation()


#Spawn ennemies automatically
func spawn(): get_parent().add_child(load("res://common/entities/enemies/common_bubble/common_bubble.tscn").instantiate())


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

func has_weapon(weapon) -> bool:
	var children = $Weapons.get_children()
	for child in children:
		if is_instance_of(child, weapon):
			return true
	return false

# upgrade handler
func increase_health(amount: int) -> void:
	max_health += amount
	health = max_health
	_update_health_ui()

func increase_speed(amount: float) -> void:
	speed *= amount

func add_weapon(weapon) -> void:
	if weapon == Mop:
		var weapon_instance = load("res://common/entities/weapons/mop/mop.tscn").instantiate()
		$Weapons.add_child(weapon_instance)
	elif weapon == NailGun:
		var weapon_instance = load("res://common/entities/weapons/nail_gun/nail_gun.tscn").instantiate()
		$Weapons.add_child(weapon_instance)

func update_weapon_damage(weapon, amount: int) -> void:
	damages[weapon] += amount
	for child in $Weapons.get_children():
		if is_instance_of(child, weapon):
			child.set_weapon_damage(damages[weapon])

func update_weapon_range(weapon, factor: float) -> void:
	ranges[weapon] *= factor
	for child in $Weapons.get_children():
		if is_instance_of(child, weapon):
			child.set_weapon_range(ranges[weapon])

func update_weapon_delay(weapon, factor: float) -> void:
	delays[weapon] *= factor
	for child in $Weapons.get_children():
		if is_instance_of(child, weapon):
			child.set_weapon_delay(delays[weapon])
