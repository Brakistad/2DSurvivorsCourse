extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hurt_box_component = $HurtboxComponent as HurtboxComponent
@onready var random_stream_player_component = $HitRandomAudioPlayerComponent


func _ready():
	hurt_box_component.hit.connect(on_hit)


func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	

func on_hit():
	random_stream_player_component.play_random()