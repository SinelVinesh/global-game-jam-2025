class_name BossState extends EnemyState

const DASH_BACK = "dash_back"
const ATTACK_BUBBLE_BARRAGE = "attack_bubble_barrage"
const ATTACK_BUBBLE_DROP = "attack_bubble_drop"

func _ready() -> void :
	await owner.ready
	enemy = owner as Boss
	assert(enemy != null, "The BossState state needs the owner to be a Boss node.")
