extends CanvasLayer


enum UPGRADE {
	# Character upgrades
	HEALTH_UP, # Increase player health and reset health to max
	SPEED_UP, # Increase player speed
	# Mop upgrades
	ADD_WEAPON_MOP,
	MOP_DAMAGE_UP,
	MOP_RANGE_UP,
	MOP_ATTACK_SPEED_UP,
	# Nail gun upgrades
	ADD_WEAPON_TOWEL,
	TOWEL_DAMAGE_UP,
	TOWEL_RANGE_UP,
	TOWEL_ATTACK_SPEED_UP,
}

class Upgrade: 
	var type: UPGRADE
	var name: String
	var description: String

	static func init(new_type: UPGRADE, new_name: String, new_description: String) -> Upgrade:
		var upgrade = Upgrade.new()
		upgrade.type = new_type
		upgrade.name = new_name
		upgrade.description = new_description
		return upgrade

var upgrade_list: Array[Upgrade] = [
	Upgrade.init(UPGRADE.HEALTH_UP, "Open your eyes !", "Increase player health and reset health to max"),
	Upgrade.init(UPGRADE.SPEED_UP, "Faster than light !", "Increase player speed"),
	Upgrade.init(UPGRADE.ADD_WEAPON_MOP, "Mop the flooor", "Add a mop weapon to the player"),
	Upgrade.init(UPGRADE.MOP_DAMAGE_UP, "More soaaap ", "Increase mops damage"),
	Upgrade.init(UPGRADE.MOP_RANGE_UP, "Streeeeeaching", "Increase mops range"),
	Upgrade.init(UPGRADE.MOP_ATTACK_SPEED_UP, "Quicker Janitor !", "Increase mop attack speed"),
	Upgrade.init(UPGRADE.ADD_WEAPON_TOWEL, "The Towel !", "Throw a towel at your enemies"),
	Upgrade.init(UPGRADE.TOWEL_DAMAGE_UP, "Twist it <3", "Increase towels damage"),
	Upgrade.init(UPGRADE.TOWEL_RANGE_UP, "3 points !", "Increase towels range"),
	Upgrade.init(UPGRADE.TOWEL_ATTACK_SPEED_UP, "It's wet !", "Increase towels attack speed"),
]

var _player : Player
var proposed_upgrades = []
var excluded_upgrades = []
@onready var upgrade_1: Control = %Upgrade1
@onready var upgrade_2: Control = %Upgrade2
@onready var upgrade_3: Control = %Upgrade3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_upgrade_screen(player: Player):
	if _player == null:
		_player = player
	get_tree().paused = true
	# Exclude some upgrade based on player weapons
	excluded_upgrades.clear()
	if !_player.has_weapon(Mop):
		excluded_upgrades.push_back(UPGRADE.MOP_DAMAGE_UP)
		excluded_upgrades.push_back(UPGRADE.MOP_RANGE_UP)
		excluded_upgrades.push_back(UPGRADE.MOP_ATTACK_SPEED_UP)
	if !_player.has_weapon(Towel):
		excluded_upgrades.push_back(UPGRADE.TOWEL_DAMAGE_UP)
		excluded_upgrades.push_back(UPGRADE.TOWEL_RANGE_UP)
		excluded_upgrades.push_back(UPGRADE.TOWEL_ATTACK_SPEED_UP)
	# Get 3 random exclusive upgrades
	var available_upgrades = upgrade_list.duplicate()
	available_upgrades = available_upgrades.filter(func (upgrade: Upgrade): return !excluded_upgrades.has(upgrade.type))
	proposed_upgrades.clear()
	for i in range(3):
		var index = randi() % available_upgrades.size()
		proposed_upgrades.push_back(available_upgrades[index])
		available_upgrades.remove_at(index)
	_update_upgrade_ui()
	show()

func _update_upgrade_ui():
	_update_ui_for_card(upgrade_1, proposed_upgrades[0])
	_update_ui_for_card(upgrade_2, proposed_upgrades[1])
	_update_ui_for_card(upgrade_3, proposed_upgrades[2])

func _update_ui_for_card(card: Control, upgrade: Upgrade):
	card.get_node("Title").text = "[wave amp=80 freq=5][center]\n" + upgrade.name
	card.get_node("Description").text = upgrade.description
	card.upgrade = upgrade

func select_upgrade(upgrade: Upgrade):
	proposed_upgrades.clear()
	hide()
	get_tree().paused = false

	match upgrade.type:
		UPGRADE.HEALTH_UP:
			_player.increase_health(10)
		UPGRADE.SPEED_UP:
			_player.increase_speed(1.5)
		UPGRADE.ADD_WEAPON_MOP:
			_player.add_weapon(Mop)
		UPGRADE.MOP_DAMAGE_UP:
			_player.update_weapon_damage(Mop, 15)
		UPGRADE.MOP_RANGE_UP:
			_player.update_weapon_range(Mop, 1.5)
		UPGRADE.MOP_ATTACK_SPEED_UP:
			_player.update_weapon_delay(Mop, 0.5)
		UPGRADE.ADD_WEAPON_TOWEL:
			_player.add_weapon(Towel)
		UPGRADE.TOWEL_DAMAGE_UP:
			_player.update_weapon_damage(Towel, 10)
		UPGRADE.TOWEL_RANGE_UP:
			_player.update_weapon_range(Towel, 1.5)
		UPGRADE.TOWEL_ATTACK_SPEED_UP:
			_player.update_weapon_delay(Towel, 0.5)
