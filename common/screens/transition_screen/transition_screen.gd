extends Control

signal on_transition_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ColorRect.visible = false
	%AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "normal_to_black":
		on_transition_finished.emit()
		%AnimationPlayer.play("black_to_normal")
	elif anim_name == "black_to_normal":
		%ColorRect.visible = false

func transition():
	%ColorRect.visible = true
	%AnimationPlayer.play("normal_to_black")
