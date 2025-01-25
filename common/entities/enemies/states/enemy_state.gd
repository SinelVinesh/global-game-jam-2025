class_name EnemyState extends State

const IDLE = "Idle"
const FOLLOW = "Follow"

var enemy: Enemy

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null, "The EnemyState state needs the owner to be a Enemy node.")
