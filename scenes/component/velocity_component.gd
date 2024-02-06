extends Node
class_name VelocityComponent

signal signal_velocity_treshold_reached
signal signal_velocity_treshold_lost

@export var max_speed: int = 40
@export var acceleration: float = 5
@export var distancing: float = 100
@export var randomize_distancing: float = 200
@export var sprint_speed_percent: float = 2

var velocity = Vector2.ZERO
var distancing_walker_band_distance = 0
var sprinting = false
var velocity_treshold = 0.1
var velocity_treshold_set = false
var velocity_treshold_reached = false


func _ready():
	distancing_walker_band_distance = distancing + randf_range(-randomize_distancing, randomize_distancing)

func set_velocity_treshold(value: float):
	velocity_treshold = value
	velocity_treshold_set = true

func get_sprint_factor():
	if !sprinting:
		return 1
	else:
		return sprint_speed_percent

func get_distancing_walker_band_distance():
	var distancing_walker_band_target = distancing + randf_range(-randomize_distancing, randomize_distancing)
	distancing_walker_band_distance = lerpf(distancing_walker_band_distance, distancing_walker_band_target, 1 - exp(-acceleration * get_process_delta_time()))
	return distancing_walker_band_distance

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
	var distancing_target = get_distancing_walker_band_distance()
	var vector_to_distancing = (vector_to_player - (vector_to_player.normalized() * distancing_target)) as Vector2
	var direction = vector_to_distancing.normalized()
	accelerate_in_direction(direction)
	
func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed * get_sprint_factor()
	# here we use framerate independent lerp, because players can play at different fps
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func decelerate():
	accelerate_in_direction(Vector2.ZERO)

func move(character_body: CharacterBody2D): 
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
	if velocity_treshold_set:
		if velocity.length() > velocity_treshold and !velocity_treshold_reached:
			signal_velocity_treshold_reached.emit()
			velocity_treshold_reached = true
		elif velocity.length() < velocity_treshold and velocity_treshold_reached:
			signal_velocity_treshold_lost.emit()
			velocity_treshold_reached = false
			
