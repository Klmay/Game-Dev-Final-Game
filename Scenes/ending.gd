extends CanvasLayer

@onready var text_content = $VBoxContainer

func _ready():
	$VBoxContainer.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1, 3)
	await get_tree().create_timer(10).timeout
	Global.reset_for_menu()
	get_tree().change_scene_to_file("res://main_menu.tscn")
