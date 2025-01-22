extends CharacterBody2D


@export var speed = 100


var player_position


func _ready():
	player_position = get_parent().get_node("Player").global_position
	position = player_position + Vector2(1000, 0).rotated(randf_range(0, 2 * PI))
	velocity = (player_position - position).normalized() * speed


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
