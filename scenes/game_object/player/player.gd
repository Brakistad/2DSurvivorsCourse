extends CharacterBody2D
class_name Player

const SPRINT_SPEED_PERCENT = 2

@onready var damage_interval_timer = $DamageIntervalTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var stamina_component = $StaminaComponent as StaminaComponent
@onready var stamina_bar = $StaminaBar as ProgressBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hit_random_stream_player = $HitRandomStreamPlayer as RandomStreamPlayer2DComponent

var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed

	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	stamina_component.stamina_changed.connect(on_stamina_changed)
	GameEvents.abiltiy_upgrade_added.connect(on_ability_upgrade_added)
	update_stamina_display()


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()

	velocity_component.sprinting = false
	if Input.is_action_pressed("sprint") && stamina_component.can_use_stamina(5):
		velocity_component.sprinting = true
		stamina_component.use_stamina_cost(.8)
	else:
		stamina_component.using_stamina = false
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	GameEvents.emit_player_damaged()
	health_component.damage(1)
	damage_interval_timer.start()
	hit_random_stream_player.play_random()

func update_stamina_display():
	stamina_bar.value = stamina_component.get_stamina_percent()

func on_body_entered(_other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(_other_body: Node2D):
	number_colliding_bodies -= 1
	
func on_damage_interval_timer_timeout():
	check_deal_damage()

func on_stamina_changed():
	update_stamina_display()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child((ability.ability_controller_scene as PackedScene).instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed * (1 + current_upgrades["player_speed"]["quantity"] * .1)
