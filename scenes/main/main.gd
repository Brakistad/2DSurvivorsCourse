extends Node

@export var end_screen_scene: PackedScene

@onready var player_one = $%Player as Player
@onready var player_two = $%Player2 as Player2

var pause_menu_scene: PackedScene = preload("res://scenes/ui/pause_menu.tscn")


func _ready():
    player_one.health_component.died.connect(on_player_died)
    player_two.health_component.died.connect(on_player_died)
    

func _unhandled_input(event):
    if event.is_action_pressed("pause"):
        var pause_menu_instance = pause_menu_scene.instantiate()
        add_child(pause_menu_instance)
        get_tree().root.set_input_as_handled()


func on_player_died():
    var end_screen_instance = end_screen_scene.instantiate() as EndScreen
    add_child(end_screen_instance)
    end_screen_instance.set_defeat()
    MetaProgression.save_file()
