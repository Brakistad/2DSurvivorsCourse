extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")
var upgrade_scene = preload("res://scenes/ui/meta_menu.tscn")

func _ready():
    $%PlayButton.pressed.connect(on_play_pressed)
    $%OptionsButton.pressed.connect(on_options_pressed)
    $%QuitButton.pressed.connect(on_quit_pressed)
    $%UpgradesButton.pressed.connect(on_upgrades_pressed)


func on_play_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")
    MetaProgression.load_file()

func on_options_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    var options_instance = options_scene.instantiate()
    add_child(options_instance)
    options_instance.back_pressed.connect(on_options_closed.bind(options_instance))

func on_quit_pressed():
    get_tree().quit()

func on_options_closed(options_instance: Node):
    # Just calling queue_free() on the instance will cause nested nodes, 
    # like the sound buttons sound effect wont play
    # This is solved using a timing mechanic in the signal handling at the transition
    # which causes the queue_free() to wait for the transition to be halfway done
    options_instance.queue_free()

func on_upgrades_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    GameEvents.last_scene = "main_menu"
    get_tree().change_scene_to_packed(upgrade_scene)