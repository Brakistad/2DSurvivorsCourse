extends Node

const SPAWN_RADIUS = sqrt(pow(320,2)+pow(180,2)) + 10

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer as Timer

var base_spawn_time = 0


func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	var spawn_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	var spawn_subdivisions = 4 # hard coded value for subdividing the linear seek on no collide angle
	var angle_rotation = TAU / spawn_subdivisions
	for i in spawn_subdivisions: # Could also be called recursive, but might be a overloaded call stack
		spawn_position = player.global_position + (spawn_direction * SPAWN_RADIUS)
		
		# Some raycast magic here 🎇
		# bit shift here is a illustration of how to easily reference mask in code i.e 1 << 19 for mask 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0) 
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) as Dictionary
		if result.is_empty():
			# We are clear
			return spawn_position
		else:
			# we have a collision
			spawn_position = spawn_direction.rotated(angle_rotation)
	return spawn_position
	
	


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(current_difficulty: int):
	var time_off = (.1 / 12) * current_difficulty
	time_off = min(time_off, .9)
	print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	
