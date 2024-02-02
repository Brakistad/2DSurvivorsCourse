extends Node2D
class_name HealthBarComponent

@export var health_component: HealthComponent
# export for a selection of health bar sizes
@export_enum("tiny", "small", "medium", "large") var health_bar_size: String = "medium"

@onready var health_bar = $HealthBar as ProgressBar

func _ready():
	health_component.health_changed.connect(on_health_changed)
	update_health_display()
	set_size(health_bar_size)


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_health_changed():
	update_health_display()

func set_size(size: String):
	match size:
		"tiny":
			health_bar.custom_minimum_size = Vector2(8, 1)
			health_bar.size = Vector2(8, 1)
			health_bar.position = Vector2(-4, -18)
		"small":
			health_bar.custom_minimum_size = Vector2(16, 2)
			health_bar.size = Vector2(16, 2)
			health_bar.position = Vector2(-8, -18)
		"medium":
			health_bar.custom_minimum_size = Vector2(32, 4)
			health_bar.size = Vector2(32, 4)
			health_bar.position = Vector2(-16, -22)
		"large":
			health_bar.custom_minimum_size = Vector2(64, 8)
			health_bar.size = Vector2(64, 8)
			health_bar.position = Vector2(-32, -24)
		_:
			print("Invalid size: ", size)
		

