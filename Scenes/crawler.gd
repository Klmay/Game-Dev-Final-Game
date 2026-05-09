extends CharacterBody2D

@export_enum("level", "level_2") var assigned_level: String = "level"

@export var dash_direction: Vector2 = Vector2(0, 1)
@export var dash_distance: float = 1200 
@export var dash_speed: float = 0.5 
@export var is_lethal: bool = false 
var ready_to_scare: bool = false

func _ready():
	hide()
	$CollisionShape2D.disabled = true
	$Area2D/DeathZone.set_deferred("disabled", true)
	Global.puzzle_updated.connect(_on_puzzle_step_changed)
	await get_tree().process_frame 
	if Global.dialogue_box:
		Global.dialogue_box.dialogue_finished.connect(_on_dialogue_closed)

func _on_puzzle_step_changed(step):
	if assigned_level == "level" and step == 6:
		ready_to_scare = true
	elif assigned_level == "level_2" and step == 5:
		ready_to_scare = true

func _on_dialogue_closed():
	if ready_to_scare:
		show()
		$CollisionShape2D.disabled = false
		$Area2D/DeathZone.set_deferred("disabled", false)
		perform_dash()

func perform_dash():
	ready_to_scare = false 
	var target_pos: Vector2
	if assigned_level == "level_2":
		audio.play_crawler_movement(true)
	else:
		audio.play_crawler_movement(false)
	Global.shake_screen(12, 0.5)
	if assigned_level == "level_2":
		var player = get_tree().get_first_node_in_group("player")
		if player:
			target_pos = player.global_position
		else:
			target_pos = global_position + (dash_direction * dash_distance)
	else:
		target_pos = global_position + (dash_direction * dash_distance)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, dash_speed)\
		.set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(queue_free)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and is_lethal:
		body.set_physics_process(false) 
		audio.play_death_scream()
		get_tree().change_scene_to_file("res://ending.tscn")
