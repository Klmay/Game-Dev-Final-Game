extends CanvasLayer

@onready var container = $Control/VBoxContainer

func _ready():
	var labels = container.get_children()
	for label in labels:
		label.modulate.a = 0
	run_intro_sequence(labels)

func run_intro_sequence(labels):
	var tween = create_tween()
	for i in range(labels.size()):
		tween.tween_property(labels[i], "modulate:a", 3, 3)
		tween.tween_interval(0.5) 
	tween.tween_interval(2)
	for i in range(5): 
		tween.parallel().tween_property(labels[i], "modulate:a", 0, 1)
	tween.tween_interval(3)
	tween.tween_callback(func():
		FadeInFadeOut.transition_to("res://level.tscn")
)

func _input(event):
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		FadeInFadeOut.transition_to("res://level.tscn")
		get_viewport().set_input_as_handled()
