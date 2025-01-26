class_name Enemy extends CharacterBody2D

@export var speed = 100
@export var damage = 1
@export var max_health = 30
@export var exp_point_min = 5
@export var exp_point_max = 15

@export var flip_animation = false

@onready var animation_player = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var rangebox = $Range
@onready var animated_sprite = $AnimatedSprite2D
var distance_to_player

var health
var player_position
var damage_taken = 0
var experience_point = 0


func _ready():
	player_position = get_parent().get_node("Player").global_position
	position = player_position + Vector2(1000, 0).rotated(randf_range(0, 2 * PI))
	velocity = (player_position - position).normalized() * speed

	health = max_health
	$Control_Enemy/TXProgressBar_Health.max_value = health
	_update_health_ui()

	experience_point = randi_range(exp_point_min, exp_point_max)

func _physics_process(_delta:float)-> void:
	player_position = get_parent().get_node("Player").global_position
	distance_to_player = position.distance_to(player_position)

#Update health ui
func _update_health_ui():
	$Control_Enemy/TXProgressBar_Health.value = health

#Handle receive damage
func _receive_damage():
	health -= damage_taken
	_update_health_ui()
	if health <= 0:
		_give_experience()
	else:
		animation_player.play("Enemy_Hit")


#Handle rexperience given to player
func _give_experience():
	var player_owner = get_parent().get_node("Player")
	var experience_gained = experience_point
	player_owner.get_node("Experience_Player")._gain_experience(experience_gained)
	animation_player.play("Death")
