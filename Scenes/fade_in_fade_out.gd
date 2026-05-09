extends CanvasLayer

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var fadeOutTimer: Timer = $FadeOutTimer
var target_scene: String

func transition_to(scene_path: String):
	target_scene = scene_path
	fadeOutTimer.start()

func _on_fade_out_timer_timeout():
	animPlayer.play("fade_out")
	await animPlayer.animation_finished
	get_tree().change_scene_to_file(target_scene)
	animPlayer.play("fade_in")
