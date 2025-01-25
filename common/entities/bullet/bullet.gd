extends Node2D


@export var weapon_damage = 20



#Handle hit ennemy
func enemyHit(area: Area2D):
	var any_enemy_hit = area.get_parent()
	var player_owner = get_parent()
	#var experience_gained = any_enemy_hit.experience_point
	#player_owner.get_node("Experience_Player")._gain_experience(experience_gained)
	any_enemy_hit.damage_taken = weapon_damage
	any_enemy_hit._receive_damage()
