extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer

var is_moving = false

func _ready():
	var arena_time_manager = get_tree().get_first_node_in_group("time_manager_group") as ArenaTimeManager
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func _process(_delta):
	if is_moving:
		velocity_component.accelerate_to_player_distance()
	else:
		velocity_component.decelerate()

	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0 && velocity.length() > .5 * velocity_component.max_speed:
		visuals.scale = Vector2(move_sign, 1)
	


func set_is_moving(moving: bool):
	is_moving = moving


func on_arena_difficulty_increased(current_difficulty: int):
	velocity_component.distancing = max(0, velocity_component.distancing - 5 * current_difficulty)