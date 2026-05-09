extends CanvasLayer

func _ready():
	if Global.dialogue_box:
		Global.dialogue_box.hide()
		Global.reset_for_menu()

func _on_play_button_pressed():
	Global.current_save = GameSave.new()
	Global.current_save.player_position = Vector2.ZERO
	Global.puzzle_step = 0
	FadeInFadeOut.transition_to("res://intro.tscn")

func _on_options_pressed():
	$Control/Main_Menu.hide()
	$Control/Options.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_new_save_pressed():
	Global.current_save = GameSave.new()
	Global.current_save.player_position = Vector2.ZERO
	Global.puzzle_step = 0
	managing_saves.save_game(Global.current_save)
	FadeInFadeOut.transition_to("res://intro.tscn")

func _on_load_save_pressed():
	var loaded_data = managing_saves.load_game()
	Global.current_save = loaded_data
	Global.puzzle_step = loaded_data.saved_puzzle_step
	FadeInFadeOut.transition_to(loaded_data.saved_scene)

func _on_back_pressed():
	$Control/Options.hide()
	$Control/Main_Menu.show()
