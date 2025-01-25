extends Control


@export var level = 1

var experience = 0
var experience_required = _get_experience_required(level + 1)
var amount


signal pause_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	$Label_Experience.text = str(experience)
	$Label_Experience_required.text = str(experience_required)
	$Label_Level.text = str (level)


#Get random experience required to level up
func _get_experience_required(level):
	return round (pow (level, 3) + level * 50)


#Handle experience gaining
func _gain_experience(amount):
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		_level_up()


#Handle leveling up
func _level_up():
	level += 1
	experience_required = _get_experience_required(level + 1)
	emit_signal("pause_game")
