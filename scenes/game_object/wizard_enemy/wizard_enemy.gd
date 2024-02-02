extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals


func _process(_delta):
	velocity_component.accelerate_to_player_distance()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0 && velocity.length() > .5 * velocity_component.max_speed:
		visuals.scale = Vector2(move_sign, 1)
	
