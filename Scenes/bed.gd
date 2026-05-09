extends StaticBody2D

enum Step {NOTE, GLOBE, VANITY, WARDROBE, BED, DIARY}

@export var item_type: Step
@export_multiline var flavor_text: String = "You recognize your mother's locket and wish you could have said goodbye...."
@export_multiline var clue_text: String = "Helping you one last time, your mother's locket grants you a new key."

func interact():
	if not Global.dialogue_box: return
	if item_type == Step.DIARY:
		Global.dialogue_box.show_dialogue(flavor_text)
		return
	if Global.puzzle_step == item_type:
		Global.dialogue_box.show_dialogue(clue_text)
		if item_type == Step.BED:
			Global.puzzle_step += 1 
			return 
		Global.puzzle_step += 1
	elif Global.puzzle_step < item_type:
		Global.dialogue_box.show_dialogue(flavor_text)
	else:
		Global.dialogue_box.show_dialogue("I've already searched this.")
