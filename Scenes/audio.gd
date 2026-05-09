extends Node

func play_transition_footsteps():
	var sfx = AudioStreamPlayer.new()
	get_tree().root.add_child(sfx) 
	sfx.stream = load("res://assets/sounds/footsteps.mp3")
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_crawler_movement(is_level_two: bool):
	var sfx = AudioStreamPlayer.new()
	add_child(sfx)
	
	if is_level_two:
		sfx.stream = load("res://assets/sounds/glass_smash.mp3")
	else:
		sfx.stream = load("res://assets/sounds/grass_run.mp3")
	sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_death_scream():
	var sfx = AudioStreamPlayer.new()
	get_tree().root.add_child(sfx) 
	sfx.stream = load("res://assets/sounds/scream.mp3") 
	sfx.pitch_scale = randf_range(0.9, 1.1)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
