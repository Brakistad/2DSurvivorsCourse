extends Node


@export var knife_ability_scene: PackedScene

@onready var timer = $Timer as Timer

var damage = 10


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	if owner == null:
		return
	var enemy = owner.get_parent() as Node2D
	if enemy == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
	
	var knife_instance = knife_ability_scene.instantiate() as KnifeAbility
	foreground_layer.add_child(knife_instance)
	knife_instance.global_position = enemy.global_position
