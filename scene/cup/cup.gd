extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vanish: AudioStreamPlayer2D = $Vanish

func die() -> void:
	animation_player.play("vanish")
	vanish.play()
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SignalManager.on_cup_destroyed.emit()
	queue_free()
	
