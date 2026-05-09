extends StaticBody2D

enum Step {NOTE, GLOBE, VANITY, WARDROBE, BED, DIARY}

@export var item_type: Step
@export_multiline var flavor_text: String = "September 27th, 1965: I don't recognize my husband anymore. He says strange things when he thinks I'm not listening. He locks himself in his study more frequently than before. The show being canceled took a toll on him in a way I wasn't expecting. The house will not let us out. We try, and it shifts the rooms, yet it seems to listen to him. I don't know for certain why he's done this, but I feel relief in knowing our children were not trapped in here along with us."
@export_multiline var clue_text: String = "September 27th, 1965: I don't recognize my husband anymore. He says strange things when he thinks I'm not listening. He locks himself in his study more frequently than before. The show being canceled took a toll on him in a way I wasn't expecting. The house will not let us out. We try, and it shifts the rooms, yet it seems to listen to him. I don't know for certain why he's done this, but I feel relief in knowing our children were not trapped in here along with us."

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
