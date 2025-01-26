extends Area2D

var _damage : int 
var _velocity: Vector2
var _speed: int
var _max_distance_travelled = 1000.0
var _distance_travelled: float

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	self.body_entered.connect(_on_hitbox_body_entered)

func init_bullet(damage: int, speed: int, direction: Vector2) -> void:
	_damage = damage
	_speed = speed
	_velocity = direction * _speed

func _physics_process(_delta: float) -> void:
	var distance = _velocity * _delta
	global_position += distance
	_distance_travelled += distance.length()
	if _distance_travelled > _max_distance_travelled:
		queue_free()

func _on_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("Hurtbox") and body is Enemy:
		body.damage_taken = _damage
		body._receive_damage()
		queue_free()
