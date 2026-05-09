extends Node2D

func _ready():
	if Global.puzzle_step > 5: 
		Global.puzzle_step = 0  

	var spawn_node = get_node_or_null("spawn")
	var player = get_tree().get_first_node_in_group("player")
	if spawn_node and player:
		player.global_position = spawn_node.global_position
