extends Node
class_name StaminaComponent

signal stamina_changed

@export var max_stamina: float = 100
@export var recharge_rate: float = 0.2

@onready var stamina_timer: Timer = $Timer # used to tick down and up stamina

var current_stamina: float = max_stamina
var using_stamina: bool = false
var cost: float = 1.0

func _ready():
    stamina_timer.timeout.connect(on_timer_timeout)
    stamina_timer.wait_time = 0.005

func recharge():
    if current_stamina < max_stamina:
        current_stamina += recharge_rate
        stamina_changed.emit()

func use_stamina():
    if current_stamina > 0:
        current_stamina -= clampf(cost, 0, current_stamina) # clamp to prevent negative stamina
        stamina_changed.emit()
    else:
        using_stamina = false
        cost = 1.0


func use_stamina_cost(current_cost: float):
    cost = current_cost
    using_stamina = true


func can_use_stamina(current_cost: float):
    if current_stamina - current_cost < 0:
        return false
    else:
        return true


func get_stamina_percent() -> float:
    return current_stamina / max_stamina


func on_timer_timeout():
    if using_stamina:
        use_stamina()
    else:
        recharge()
