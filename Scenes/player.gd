extends CharacterBody2D

@export var speed = 150
@export var interaction_range = 20
@onready var prompt = $PromptToInteract
@onready var interact_ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D

var last_direction = "down"

func _ready():
	await get_tree().process_frame
	if Global.current_save.player_position != Vector2.ZERO:
		global_position = Global.current_save.player_position

func trigger_save():
	Global.current_save.player_position = global_position
	Global.current_save.saved_puzzle_step = Global.puzzle_step
	Global.current_save.saved_scene = get_tree().current_scene.scene_file_path
	managing_saves.save_game(Global.current_save)
	print("Game Saved! Current Step: ", Global.puzzle_step)

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		interact_ray.target_position = direction * interaction_range
		update_animation("walk", direction)
	else:
		update_animation("idle", Vector2.ZERO)
	update_interaction_prompt()
	move_and_slide()
	if Input.is_action_just_pressed("interact"):
		check_interaction()

func update_interaction_prompt():
		interact_ray.force_raycast_update()
		if interact_ray.is_colliding():
			var collider = interact_ray.get_collider()
			if collider.has_method("interact"):
				prompt.show()
			elif collider is Area2D and collider.get_parent().has_method("interact"):
				prompt.show()
			else:
				prompt.hide()
		else:
			prompt.hide()

func update_animation(state, direction):
	if direction.x > 0:
		last_direction = "right"
	elif direction.x < 0:
		last_direction = "left"
	elif direction.y > 0:
		last_direction = "down"
	elif direction.y < 0:
		last_direction = "up"
	var anim_name = state + "_" + last_direction
	sprite.play(anim_name)

func check_interaction():
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider.has_method("interact"):
			collider.interact()
		elif collider is Area2D and collider.get_parent().has_method("interact"):
			collider.get_parent().interact()

func die():
	FadeInFadeOut.transition_to("res://losing.tscn")
