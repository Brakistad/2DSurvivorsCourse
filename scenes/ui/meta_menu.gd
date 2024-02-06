extends CanvasLayer

signal back_pressed

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = $%GridContainer
@onready var main_menu_button: Button = $%MainMenuButton

var meta_upgrade_card_scene: PackedScene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
    main_menu_button.pressed.connect(on_main_menu_button_pressed)
    for child in grid_container.get_children():
        child.queue_free()
    
    for upgrade in upgrades:
        var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate() as MetaUpgradeCard
        grid_container.add_child(meta_upgrade_card_instance)
        meta_upgrade_card_instance.set_meta_upgrade(upgrade)

func on_main_menu_button_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
    
