extends Area2D

var _damage: int 
var _destination: Vector2
var _velocity: Vector2
var _delay: float
var _deceleration = 0.02
var _stable_velocity: Vector2
var _teleport = false

func _on_timer_timeout() -> void:
	queue_free()

func init_bullet(damage: int, destination: Vector2, delay: float, teleport: bool) -> void:
	_damage = damage
	_delay = delay
	_destination = destination
	_velocity = (_destination - global_position).normalized() * 700
	_stable_velocity = _velocity * 0.5
	_teleport = teleport

func _physics_process(_delta: float) -> void:
	_delay -= _delta
	if _delay > 0:
		return
	if _teleport and $Timer.is_stopped():
		global_position = _destination
		$AnimationPlayer.play("falling_bubble")
		await $AnimationPlayer.animation_finished
		$Timer.set_wait_time(3)
		$Timer.start()
		return
	if global_position.distance_to(_destination) > 10:
		_velocity = _velocity.lerp(_stable_velocity, _deceleration)
		global_position = global_position + _velocity * _delta
		$Timer.start()
