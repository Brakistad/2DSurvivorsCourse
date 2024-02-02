extends CharacterBody2D
class_name Player

const MAX_SPEED = 100
const SPRINT_SPEED = 200
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var stamina_component = $StaminaComponent as StaminaComponent
@onready var stamina_bar = $StaminaBar as ProgressBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var visuals = $Visuals

var number_colliding_bodies = 0

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	stamina_component.stamina_changed.connect(on_stamina_changed)
	GameEvents.abiltiy_upgrade_added.connect(on_ability_upgrade_added)
	update_stamina_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()

	var movement_speed = MAX_SPEED
	if Input.is_action_pressed("sprint") && stamina_component.can_use_stamina(5):
		movement_speed = SPRINT_SPEED
		stamina_component.use_stamina_cost(1)
	else:
		stamina_component.using_stamina = false

	var target_velocity = direction * movement_speed
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
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
	health_component.damage(1)
	damage_interval_timer.start()

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

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	if not ability_upgrade is Ability:
		return
	
	var ability = ability_upgrade as Ability
	abilities.add_child((ability.ability_controller_scene as PackedScene).instantiate())
