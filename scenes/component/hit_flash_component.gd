extends Node


@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flashed_tween: Tween


func _ready():
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material


func on_health_changed():
	if hit_flashed_tween != null && hit_flashed_tween.is_valid():
		hit_flashed_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flashed_tween = create_tween()
	hit_flashed_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .2)
