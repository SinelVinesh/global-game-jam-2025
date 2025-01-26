extends Node

enum SoundType {
	DEAD_MOB
}

func play_sound(sound:SoundType) -> void:
	match sound:
		SoundType.DEAD_MOB:
			$DeadMob.play()
