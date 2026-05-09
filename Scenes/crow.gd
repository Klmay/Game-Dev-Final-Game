extends StaticBody2D

enum Step {NOTE, BOOKSHELF, POT, PLANT, CLOCK, CHEST, FIREPLACE}

@onready var interaction_area = $Area2D

var dialogue_list = [
	"'Oh, so you actually came. I'm surprised all things considered, but also not.'",
	"'Who am I? That's not important right now. What's important is you just played your part perfectly.'",
	"'I see that look of confusion, you really don't know what happened here do you? Hmph, typical. Humans always act before thinking.'",
	"'Well let me tell you, kid- don't give me that look, you're a kid compared to the beings in here- you made a mistake.'",
	"'Your mother is dead. Has been a long time. There's nothing for you here. The house called for you, and like a sentimental fool, you answered. Now it's on you to deal with the outcome.'",
	"'The house already knows you're here, human, he already knows you're here. You wouldn't have even gotten past the front gate if he didn't allow for you to do so. And now that you're here, he doesn't plan on letting you out.'",
	"'You can try to escape, but let me tell you something: The last people tried too, and they're still here. Have been for years. The house keeps them separated so they can't band together with the power of friendship or whatever it is you humans think can solve anything.'",
	"'But you could certainly try. It would provide me some entertainment watching you go about thinking you can outsmart a centuries old being.'",
	"'Now go away, I was napping before you came stumbling in.'"
	]

var is_player_near = false

func _ready():
	add_to_group("Crow")
	interaction_area.body_entered.connect(_on_player_entered)
	interaction_area.body_exited.connect(_on_player_exited)

func _input(event):
	if is_player_near:
		if event.is_action_pressed("interact"):
			interact()

func interact():
	if not Global.dialogue_box: return
	if Global.puzzle_step == Step.NOTE:
		Global.dialogue_box.show_dialogue(dialogue_list)
	elif Global.puzzle_step > Step.NOTE and Global.puzzle_step <= Step.POT:
		Global.dialogue_box.show_dialogue([
			"'What do you want now?'",
			"'I thought I told you to go away. I'm not here to hold your hand, human.'",
			"'Go poke around some more dust and leave me to my nap.'"
		])
	elif Global.puzzle_step > Step.POT:
		Global.dialogue_box.show_dialogue([
			"'Why are you still hovering? I already told you about the plant.'",
			"'Shoo! My patience is as thin as your chances of getting out of here.'"
		])
	else:
		Global.dialogue_box.show_dialogue(dialogue_list)

func speak_pot_clue():
	if not Global.dialogue_box: return
	Global.dialogue_box.show_dialogue([
		"As you pick up the book, you notice its pages are shredded and many are torn out",
		"'Looking for a book?' you hear the crow say from its perch, 'Too late, little lady. I shredded it.'",
		"'But since I'm bored, I'll help you out.'",
		"'If you want to see a miracle, go look at her Potted Plant. It’s the only thing in this house that still thinks it’s alive.'"
	])
	Global.puzzle_step = Step.PLANT

func _on_player_entered(body):
	if body.is_in_group("player"): is_player_near = true

func _on_player_exited(body):
	if body.is_in_group("player"): is_player_near = false
