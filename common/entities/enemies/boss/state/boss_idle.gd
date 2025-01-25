extends BossState

func enter(_previous_state_path: String, _data := {}) -> void:
    enemy.velocity = Vector2.ZERO
    enemy.animated_sprite.play("idle")
    enemy.rangebox.area_exited.connect(transition_to_follow)

func transition_to_follow(area: Area2D) -> void:
    if area.get_parent().is_in_group("Player"):
        finished.emit(FOLLOW)

func physics_update(_delta: float) -> void:
    enemy.current_bubble_barrage_timer -= _delta
    if enemy.current_bubble_barrage_timer <= 0:
        finished.emit(ATTACK_BUBBLE_BARRAGE)
    enemy.current_dash_back_timer -= _delta
    if enemy.current_dash_back_timer <= 0:
        finished.emit(DASH_BACK)
        enemy.current_dash_back_timer = enemy.dash_back_timer

func exit() -> void:
    enemy.rangebox.area_exited.disconnect(transition_to_follow)