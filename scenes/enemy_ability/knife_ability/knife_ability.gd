extends Node2D
class_name KnifeAbility

@onready var hurtbox_component = $HurtboxComponent

func _ready():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
