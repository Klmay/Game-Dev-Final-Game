extends StaticBody2D

enum Step {NOTE, BOOKSHELF, POT, PLANT, CLOCK, CHEST, FIREPLACE}
@export var item_type: Step
@export_multiline var flavor_text: String = "The hands are stuck at 4:00. How strange."
@export_multiline var clue_text: String = "You search the clock and the bottom panel clicks open as a key comes tumbling out."

func interact():
	if Global.puzzle_step == item_type:
		Global.dialogue_box.show_dialogue(clue_text)
		Global.puzzle_step += 1
	elif Global.puzzle_step > item_type:
		Global.dialogue_box.show_dialogue("I've already searched this.")
	elif item_type == Step.FIREPLACE and Global.puzzle_step == 6:
		Global.dialogue_box.show_dialogue("The path is clear. Time to leave.")
		Global.change_level("res://Level_2.tscn")
	else:
		Global.dialogue_box.show_dialogue(flavor_text)
