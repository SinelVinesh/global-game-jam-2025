extends Node2D


@export var weapon_damage = 20



#Handle hit ennemy
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hurtbox") and body is Enemy:
		var player_owner = get_parent()
		var experience_gained = body.experience_point
		player_owner.get_node("Experience_Player")._gain_experience(experience_gained)
		body.damage_taken = weapon_damage
		body._receive_damage()
