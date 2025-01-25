extends CanvasLayer


var available_upgrade = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	for i in range(get_child_count()):
		var upgrade_container = get_child(i)
		if upgrade_container.get_child(0).name == "player_upgrade":
			var upgrade_found = upgrade_container.get_child(0)
			available_upgrade.append(upgrade_found)

	for i in range(available_upgrade.size()):
		if available_upgrade[i] != null and available_upgrade[i].visible == true:
			available_upgrade[i].visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _show_upgrade():
	for i in range(available_upgrade.size()):
		if available_upgrade[i] != null and available_upgrade[i].visible == false:
			available_upgrade[i].visible = true
