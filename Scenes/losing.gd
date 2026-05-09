extends CanvasLayer

func _ready():
	await get_tree().create_timer(10).timeout
	Global.reset_for_menu()
	get_tree().change_scene_to_file("res://main_menu.tscn")
