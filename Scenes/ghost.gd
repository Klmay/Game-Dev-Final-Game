extends CharacterBody2D

var active = false

@export var patrol_speed: float = 50
@export var chase_speed: float = 90
@export var patrol_path_node: Node2D 

@onready var hitbox = $Hitbox 
@onready var sprite = $AnimatedSprite2D 

var waypoints: Array = []
var current_waypoint_index: int = 0
var is_chasing = false
var player = null

func _ready():
	visible = false
	active = false
	$CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.disabled = true 
	set_physics_process(true) 
	if patrol_path_node:
		waypoints = patrol_path_node.get_children()

func _physics_process(_delta):
	if not active:
		if Global.puzzle_step >= 6:
			spawn_ghost()
		else:
			return
	if is_chasing and player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * (chase_speed * 0.4)
	elif waypoints.size() > 0:
		var target = waypoints[current_waypoint_index].global_position
		var direction = global_position.direction_to(target)
		velocity = direction * patrol_speed 
		if global_position.distance_to(target) < 25: 
			current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
	else:
		velocity = Vector2.ZERO
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	update_animations()
	move_and_slide()

func spawn_ghost():
	active = true
	show()
	sprite.show()
	sprite.play("float")
	$CollisionShape2D.set_deferred("disabled", false)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)

func update_animations():
	if is_chasing:
		sprite.play("attack")
	elif velocity.length() > 0:
		sprite.play("float")
	else:
		sprite.play("idle")

func _on_detection_area_body_entered(body):
	if active and body.is_in_group("player"):
		is_chasing = true
		player = body

func _on_detection_area_body_exited(body):
	if body == player:
		is_chasing = false
		player = null
		find_closest_waypoint()

func _on_hitbox_body_entered(body):
	if active and body.is_in_group("player"):
		if body.has_method("die"):
			body.die()

func find_closest_waypoint():
	var closest_dist = INF
	for i in range(waypoints.size()):
		var dist = global_position.distance_to(waypoints[i].global_position)
		if dist < closest_dist:
			closest_dist = dist
			current_waypoint_index = i
