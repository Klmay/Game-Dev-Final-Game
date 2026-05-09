extends CanvasLayer

@onready var clue_label = $Control/Label

@export var total_clues: int = 7 

func _ready():
	Global.puzzle_updated.connect(_update_hud)
	_update_hud(Global.puzzle_step)

func _update_hud(current_step):
	clue_label.text = "Clues: " + str(current_step) + " / " + str(total_clues)
