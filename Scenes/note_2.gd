extends StaticBody2D

enum Step {NOTE, GLOBE, VANITY, WARDROBE, BED, DIARY}

@export var item_type: Step
@export_multiline var flavor_text: String = "A note."
@export_multiline var clue_text: String = "'He wept as he remembered the promises he made to the love of his life, knowing he had failed her and her dreams to travel by keeping her here.'"

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
