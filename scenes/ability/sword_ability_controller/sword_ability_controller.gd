extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = ($Timer as Timer).wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.abiltiy_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_this_player_target() as Node2D
	if player == null:
		return false
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(close_to_player)
	# filter enemies, that have the compenent Node of type "FadingGhostComponent", and apply a filter to that subgroup
	var ghost_enemies = enemies.filter(check_component.bind("FadingGhostComponent"))
	enemies = enemies.filter(check_component.bind("FadingGhostComponent", false))
	# add the groups together
	enemies.append_array(ghost_enemies)
	
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(sort_closest_to_player)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func check_component(enemy: Node2D, component_name: String, check_has: bool = true):
	if check_has:
		# we then also check if the component is_faded is false
		return enemy.has_node(component_name) && !enemy.get_node(component_name).is_faded
	else:
		return !enemy.has_node(component_name)

func close_to_player(enemy: Node2D):
	var player = get_this_player_target()
	if player == null:
		return false
	return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	

func sort_closest_to_player(a: Node2D, b: Node2D):
	var player = get_this_player_target()
	if player == null:
		return false
	var a_distance = a.global_position.distance_squared_to(player.global_position)
	var b_distance = b.global_position.distance_squared_to(player.global_position)
	return a_distance < b_distance

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		($Timer as Timer).wait_time = base_wait_time * max((1 - percent_reduction), 0)
		($Timer as Timer).start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)

func get_this_player_target():
	var player = self.get_parent().get_parent() as Node2D
	if player == null:
		return null
	return player
