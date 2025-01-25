extends Area2D

@export var damage = 3 
var _destination: Vector2
var _velocity: Vector2
var _delay: float
var _deceleration = 0.05
var _stable_velocity: Vector2

func _on_timer_timeout() -> void:
	queue_free()

func set_destination(destination: Vector2, delay: float) -> void:
	_delay = delay
	_destination = destination
	_velocity = (_destination - global_position).normalized() * 700
	_stable_velocity = _velocity * 0.2

func _physics_process(_delta: float) -> void:
	_delay -= _delta
	if _delay > 0:
		return
	if global_position.distance_to(_destination) > 10:
		_velocity = _velocity.lerp(_stable_velocity, _deceleration)
		global_position = global_position + _velocity * _delta
		$Timer.start()
