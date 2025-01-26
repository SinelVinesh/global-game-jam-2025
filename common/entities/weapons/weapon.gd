class_name Weapon extends Node

@export var initial_damage = 20
@export var initial_delay = 1
@export var initial_range = 1

@onready var animation_player = $AnimationPlayer

class EnemyInRange:
	var enemy: Enemy
	var distance: float
	var targeted = false
	var in_range_of: Array[Weapon] = []

var _player: Node2D
var _damage: int
var _delay: float
var _range: float
static var _enemies_in_range: Array[EnemyInRange] = []
var _active = false

func init(_init_delay: int, _init_damage: int, _init_range: int) -> void:
	set_weapon_damage(_init_damage)
	set_weapon_delay(_init_delay)
	set_weapon_range(_init_range)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_damage = initial_damage
	_delay = initial_delay
	_range = initial_range
	$Range.body_entered.connect(_on_range_body_entered)
	$Range.body_exited.connect(_on_range_body_exited)
	if $Hitbox:
		$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	_player = get_parent().get_parent()



func _physics_process(delta: float) -> void:
	if _delay > 0:
		_delay -= delta
	else:
		_active = true
		_attack()
		_delay = initial_delay

func _attack() -> void:
	for enemy in _enemies_in_range:
		enemy.distance = _player.global_position.distance_to(enemy.enemy.global_position)
	_enemies_in_range.sort_custom(func(a, b): return a.distance > b.distance)
	pass

func _on_range_body_entered(body: Node) -> void:
	var enemy = EnemyInRange.new()
	enemy.enemy = body
	enemy.in_range_of.push_back(self)
	_enemies_in_range.push_back(enemy)

func _on_range_body_exited(body: Node) -> void:
	for enemy in _enemies_in_range:
		if enemy.enemy == body:
			enemy.in_range_of.erase(self)
			_enemies_in_range.erase(enemy)
			break

func _on_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("Hurtbox") and body is Enemy and _active:
		body.damage_taken = _damage
		body._receive_damage()

func get_nearest_untargeted_enemy(weapon: Weapon, current_target: EnemyInRange) -> EnemyInRange:
	var result = null
	if current_target:
		current_target.targeted = false
	for enemy in _enemies_in_range:
		if enemy.in_range_of.has(weapon):
			if result != null :
				if enemy.distance < result.distance:
					result = enemy
			else :
				result = enemy
			if not enemy.targeted:
				enemy.targeted = true
				result = enemy
				break
	return result

func set_weapon_damage(damage: int) -> void:
	_damage = damage

func set_weapon_delay(factor: float) -> void:
	_delay = factor

func set_weapon_range(factor: float) -> void:
	_range = factor
	$Range.scale = Vector2(_range, _range)
