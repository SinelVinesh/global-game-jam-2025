extends CharacterBody2D
func _ready(): 
	position = get_parent().get_node("Player").position + Vector2(1000, 0).rotated(randf_range(0, 2*PI))
	set_velocity((get_parent().get_node("Player").position - position).normalized() * $AnimatedSprite2D.speed_scale / delta)
	move_and_slide()
func _physics_process(delta): 
	velocity
