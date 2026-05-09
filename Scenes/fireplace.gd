extends StaticBody2D

enum Step {NOTE, BOOKSHELF, POT, PLANT, CLOCK, CHEST, FIREPLACE}
@export var item_type: Step
@export_multiline var flavor_text: String = "The fire still burns yet the home still feels cold..."
@export_multiline var clue_text: String = ""
var is_player_in_range: bool = false

func interact():
	if not Global.dialogue_box: return
	if item_type == Step.FIREPLACE and Global.puzzle_step == 6:
		Global.dialogue_box.show_dialogue("Extinguishing the flames, you find a door that you swore wasn't there before.")
		await Global.dialogue_box.dialogue_finished
		audio.play_transition_footsteps() 
		await get_tree().create_timer(1.5).timeout 
		if Global.dialogue_box.has_method("hide_dialogue"):
			Global.dialogue_box.hide_dialogue()
		else:
			Global.dialogue_box.hide()
		Global.current_save.player_position = Vector2.ZERO
		FadeInFadeOut.transition_to("res://level_2.tscn")
		return
	if Global.puzzle_step == item_type:
		Global.dialogue_box.show_dialogue(clue_text)
		Global.puzzle_step += 1
		var player = get_tree().get_first_node_in_group("player") 
		if player:
			player.trigger_save()
	elif Global.puzzle_step > item_type:
		Global.dialogue_box.show_dialogue("I've already searched this.")
	else:
		Global.dialogue_box.show_dialogue(flavor_text)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		is_player_in_range = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		is_player_in_range = false
