extends Node2D


func enemyHit(area: Area2D):
	var ennemy_hit = area.get_parent()
	ennemy_hit.get_node("AnimationPlayer").play("Death")
	var player_owner = get_parent()
	var experience_gained = ennemy_hit.experience_point
	player_owner.get_node("Experience_Player")._gain_experience(experience_gained)
