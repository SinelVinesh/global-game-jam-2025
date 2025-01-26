class_name Boss extends Enemy

var initial_boss_speed = 120
var bubble_barrage_timer = 3 # 5 seconds
var current_bubble_barrage_timer = 0
var bubble_drop_timer = 5 # 5 seconds
var current_bubble_drop_timer = 5
var dash_back_timer = 7 # 10 seconds
var current_dash_back_timer = 10

func _init():
	speed = initial_boss_speed
	damage = 5
	max_health = 300
	exp_point_min = 50
	exp_point_max = 150
	flip_animation = false

#Update health ui
func _update_health_ui():
	$Control_Enemy/TXProgressBar_Health.value = health

func _physics_process(_delta: float) -> void:
	player_position = get_parent().get_node("Player").global_position
	distance_to_player = position.distance_to(player_position)
	if health <= max_health / 2:
		initial_boss_speed = 160
		bubble_barrage_timer = 2
		bubble_drop_timer = 3
		dash_back_timer = 7
		damage = 7

func init_end_screen() -> void: 
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	EndScrene.show_end_screne()
	queue_free()
