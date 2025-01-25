class_name BossState extends EnemyState

const DASH_BACK = "DashBack"
const ATTACK_BUBBLE_BARRAGE = "BubbleBarrage"
const ATTACK_BUBBLE_DROP = "BubbleDrop"

func _ready() -> void :
	await owner.ready
	enemy = owner as Boss
	assert(enemy != null, "The BossState state needs the owner to be a Boss node.")
