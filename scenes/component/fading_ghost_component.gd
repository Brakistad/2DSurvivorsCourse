extends Node

@export var sprite: Sprite2D
@export var fade_material: ShaderMaterial
@export var velocity_component: VelocityComponent
@export var health_bar_component: HealthBarComponent
@export var hurt_box_component: HurtboxComponent
@export var velocity_treshold: float = 50.0

@onready var timer_instance :Timer

var fade_in_out_tween: Tween
var is_faded: bool = false


func _ready():
	sprite.material = fade_material
	velocity_component.set_velocity_treshold(velocity_treshold)
	velocity_component.signal_velocity_treshold_reached.connect(on_velocity_treshold_reached)
	velocity_component.signal_velocity_treshold_lost.connect(on_velocity_treshold_lost)
		

func fade_invinsible(percent: float, duration_variance: float = 0.0):
	if fade_in_out_tween != null && fade_in_out_tween.is_valid():
		fade_in_out_tween.kill()
	fade_in_out_tween = create_tween()
	fade_in_out_tween.tween_property(sprite.material, "shader_parameter/invisibilty", percent, 0.2 + duration_variance)

func fade_in(percent: float, duration_variance: float = 0.0):
	# becomes visible
	fade_invinsible(percent, duration_variance)
	health_bar_component.health_bar.visible = true
	hurt_box_component.disabled = false
	is_faded = false

func fade_out(percent: float, duration_variance: float = 0.0):
	# becomes invinsible
	fade_invinsible(percent, duration_variance)
	health_bar_component.health_bar.visible = false
	hurt_box_component.disabled = true
	is_faded = true

func on_velocity_treshold_reached():
	fade_in( 0.2 - randf() * .2, randf() * 0.5)

func on_velocity_treshold_lost():
	fade_out( .8 + randf() * .2, randf() * 0.5)
