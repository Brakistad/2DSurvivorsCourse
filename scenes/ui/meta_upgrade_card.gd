extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var texture_icon: TextureRect = $%TextureIcon
@onready var cost_label = $%CostLabel
@onready var count_label = $%CountLabel
@onready var cost_bar = $%CostBar
@onready var purchase_button = $%PurchaseButton

var upgrade: MetaUpgrade

func _ready():
    purchase_button.pressed.connect(on_purchase_button_pressed)

func update_progress():
    var current_quantity = MetaProgression.get_quantity_of_meta_upgrade(upgrade.id)
    var is_maxed = current_quantity >= upgrade["max_quantity"]
    purchase_button.disabled = true
    var current_currency = MetaProgression.get_currency()
    var cost = upgrade["experience_cost"]
    cost_label.text = str(current_currency, "/", cost)
    var cost_percentage: float = 0
    if cost <= 0:
        cost_percentage = 1
    else:
        cost_percentage = float(current_currency) / float(cost)
    cost_bar.value = min(cost_percentage, 1)
    purchase_button.disabled = cost_percentage < 1 or is_maxed
    if is_maxed:
        purchase_button.text = "MAX"
    count_label.text = "x%d" % current_quantity

func set_meta_upgrade(upgrade_to_set: MetaUpgrade):
    self.upgrade = upgrade_to_set
    name_label.text = upgrade_to_set.name
    description_label.text = upgrade_to_set.description
    texture_icon.texture = upgrade_to_set.icon
    update_progress()

func select_card():
    $AnimationPlayer.play("selected")


func on_purchase_button_pressed():
    if upgrade == null:
        return
    MetaProgression.add_meta_upgrade(upgrade)
    get_tree().call_group("meta_upgrade_card", "update_progress")
    select_card()