class_name TowelGun extends Weapon

@onready var towel_bullet = preload("res://common/entities/weapons/towel_gun/towel/towel.tscn")
@export var initial_speed : int = 1000

var _speed
var current_target: EnemyInRange

func _init() -> void:
	_speed = initial_speed

func _attack() -> void :
	if _enemies_in_range.size() > 0 :
		current_target = get_nearest_untargeted_enemy(self, current_target)
		if current_target == null:
			return
		var enemy_position = current_target.enemy.global_position
		var direction = _player.global_position.direction_to(enemy_position)
		var bullet_instance = towel_bullet.instantiate()
		get_parent().add_child(bullet_instance)
		bullet_instance.init_bullet(_damage, _speed, direction)
