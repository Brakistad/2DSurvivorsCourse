extends Node2D
class_name AxeAbility

const MAX_RADIUS = 50

@export var player: Node2D = null

@onready var hitbox_component = $HitboxComponent as HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3.0).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	

func tween_method(rotations: float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	global_position = player.global_position + (current_direction * current_radius)
	
