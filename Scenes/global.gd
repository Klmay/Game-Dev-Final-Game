extends CanvasLayer

var is_shaking = false
var puzzle_step = 0:
	set(value):
		puzzle_step = value
		puzzle_updated.emit(value)
var dialogue_box = null
var has_chest_key: bool = false
var has_fireplace_key: bool = false
var current_save : GameSave = GameSave.new()
signal puzzle_updated(new_step)

@onready var music_player = $MusicPlayer
@onready var anim = $FadeToBlack
@onready var fade_overlay = $FadeOverlay

func _ready():
	current_save = managing_saves.load_game()
	puzzle_step = current_save.saved_puzzle_step
	fade_overlay.modulate.a = 0

func reset_for_menu():
	if dialogue_box:
		dialogue_box.hide()
		dialogue_box.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	puzzle_step = 0

func change_level(scene_path: String):
	current_save.player_position = Vector2.ZERO
	if anim.has_animation("fade_to_black"):
		anim.play("fade_to_black")
		await anim.animation_finished
	get_tree().change_scene_to_file(scene_path)
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Error: Could not find scene at ", scene_path)
	has_chest_key = false
	has_fireplace_key = false
	if anim.has_animation("fade_to_black"):
		anim.play_backwards("fade_to_black")
		await anim.animation_finished

func reset_game():
	has_chest_key = false
	has_fireplace_key = false
	get_tree().reload_current_scene()

func trigger_save():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		current_save.player_position = player.global_position
		current_save.saved_puzzle_step = puzzle_step
		managing_saves.save_game(current_save)

func shake_screen(intensity: float, duration: float):
	if is_shaking: return
	is_shaking = true
	var camera = get_tree().root.get_camera_2d()
	if not camera: 
		is_shaking = false
		return
	var original_offset = camera.offset
	var tween = create_tween()
	for i in range(int(duration * 20)):
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(camera, "offset", random_offset, 0.05)
	tween.tween_property(camera, "offset", original_offset, 0.05)
	tween.finished.connect(func(): is_shaking = false)
