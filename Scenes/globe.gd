extends StaticBody2D

enum Step {NOTE, GLOBE, VANITY, WARDROBE, BED, DIARY}

@export var item_type: Step
@export_multiline var flavor_text: String = "Dad always promised mom he would make enough money to travel the world with her."
@export_multiline var clue_text: String = "A scrap of paper is wedged in the equator: 'She won't look at me. She just stares into that cracked mirror on her vanity. I don't know how many times I've apologized for breaking it.'"

func interact():
	if not Global.dialogue_box: return
	if item_type == Step.DIARY:
		Global.dialogue_box.show_dialogue(flavor_text)
		return
	if Global.puzzle_step == item_type:
		Global.dialogue_box.show_dialogue(clue_text)
		if item_type == Step.BED:
			set_process_input(false)
			await get_tree().create_timer(4).timeout
			if Global.dialogue_box.has_method("hide_dialogue"):
				Global.dialogue_box.hide_dialogue()
			else:
				Global.dialogue_box.hide()
			FadeInFadeOut.transition_to("res://main_menu.tscn")
			return 
		Global.puzzle_step += 1

	elif Global.puzzle_step < item_type:
		Global.dialogue_box.show_dialogue(flavor_text)
	else:
		Global.dialogue_box.show_dialogue("I've already searched this.")
