extends Node2D


@export var speed_int = 10
@export var max_health = 100
@export var i_frames = 5

var health
var damage_taken := 0
var current_i_frames := 0

#Call when node enters main scene
func _ready() -> void:
	health = max_health
	%PlayerCamera/Control_Player/ProgressBar_Health.value = health


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


#Shoot bullet automatically
#func shoot(): add_child(load("res://common/entities/bullet/bullet.tscn").instantiate())


#Spawn ennemies automatically
func spawn(): get_parent().add_child(load("res://common/entities/enemy/enemy.tscn").instantiate())


#Restart game on player death
func restart_game():
	get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")


#Handle health
func _on_hurtbox_body_entered(body: Node2D) -> void:
	damage_taken += body.damage


func _on_hurtbox_body_exited(body: Node2D) -> void:
	damage_taken -= body.damage

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
