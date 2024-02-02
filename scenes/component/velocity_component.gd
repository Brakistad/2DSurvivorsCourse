extends Node


@export var max_speed: int = 40
@export var acceleration: float = 5
@export var distancing: float = 500
@export var randomize_distancing: float = 50

var velocity = Vector2.ZERO

func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)

func accelerate_to_player_distance():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var vector_to_player = (player.global_position - owner_node2d.global_position)
	var distance_to_player = vector_to_player.length()
	var distancing_target = distancing + randf_range(-randomize_distancing/2, randomize_distancing/2)
	var vector_to_distancing = (vector_to_player - (vector_to_player.normalized() * distancing_target)) as Vector2
	var direction = vector_to_distancing.normalized()
	accelerate_in_direction(direction)
	

func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	# here we use framerate independent lerp, because players can play at different fps
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func move(character_body: CharacterBody2D): 
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
	
