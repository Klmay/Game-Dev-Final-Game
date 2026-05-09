extends CanvasLayer

signal dialogue_finished

@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var next_indicator = $Panel/next

var dialogue_queue = [] 
var current_line_index = 0
var is_typing = false

func _ready():
	Global.dialogue_box = self
	hide()
	label.visible_ratio = 0 

func show_dialogue(input):
	if input is Array:
		dialogue_queue = input
	else:
		dialogue_queue = [input]
	
	current_line_index = 0
	show()
	display_line()
	get_tree().paused = true

func display_line():
	is_typing = true
	next_indicator.hide()
	label.text = dialogue_queue[current_line_index]
	label.visible_ratio = 0
	
	var tween = create_tween()
	var duration = label.text.length() * 0.02 
	tween.tween_property(label, "visible_ratio", 1, duration)
	tween.finished.connect(func(): 
		is_typing = false
		next_indicator.show() 
	)

func _input(event):
	if is_visible() and event.is_action_pressed("advance_dialogue"):
		if is_typing:
			is_typing = false
			label.visible_ratio = 1
			next_indicator.show()
			return

		current_line_index += 1
		if current_line_index < dialogue_queue.size():
			display_line()
		else:
			hide_dialogue()

func hide_dialogue():
	hide()
	get_tree().paused = false
	dialogue_finished.emit()
