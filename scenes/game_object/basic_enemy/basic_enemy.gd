extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals


func _ready():
	var arena_time_manager = get_tree().get_first_node_in_group("time_manager_group") as ArenaTimeManager
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
func on_arena_difficulty_increased(_current_difficulty: int):
	velocity_component.max_speed += 5