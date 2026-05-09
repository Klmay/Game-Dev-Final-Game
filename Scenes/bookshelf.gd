extends StaticBody2D

enum Step {NOTE, BOOKSHELF, POT, PLANT, CLOCK, CHEST, FIREPLACE}
@export var item_type: Step
@export_multiline var flavor_text: String = "Old books about history. Dad loved reading about folklore from different places around the world."
@export_multiline var clue_text: String = "A book is missing from the shelf, notable from the times you spent looking at its carefully organized shelves growing up. You look around, and out of the corner of your eye, you see it behind the pot! But how did it get there...?"
var is_player_in_range: bool = false

func interact():
	if not Global.dialogue_box: return
	if Global.puzzle_step == item_type:
		Global.dialogue_box.show_dialogue(clue_text)
		Global.puzzle_step += 1
		var player = get_tree().get_first_node_in_group("Player") 
		if player:
			player.trigger_save()
	elif Global.puzzle_step > item_type:
		Global.dialogue_box.show_dialogue("I've already searched this.")
	elif item_type == Step.FIREPLACE and Global.puzzle_step == 6:
		Global.dialogue_box.show_dialogue("The path is clear. Time to leave.")
		Global.change_level("res://Level2.tscn")
	else:
		Global.dialogue_box.show_dialogue(flavor_text)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		is_player_in_range = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		is_player_in_range = false
