extends CanvasLayer
class_name EndScreen

@onready var panel_container: PanelContainer = $%PanelContainer

func _ready():
    panel_container.pivot_offset = panel_container.size / 2
    var tween = create_tween()
    tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
    .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

    get_tree().paused = true
    $%ContinueButton.pressed.connect(on_continue_button_pressed)
    $%QuitButton.pressed.connect(on_quit_button_pressed)
    GameEvents.last_scene = "victory"

func set_defeat():
    ($%TitleLabel as Label).text = "Defeat"
    ($%DescriptionLabel as Label).text = "You lost 😥"
    GameEvents.last_scene = "defeat"
    play_jingle(true)

func play_jingle(defeat: bool = false):
    if defeat:
        $DefeatStreamPlayer.play()
    else:
        $VictoryStreamPlayer.play()

func change_to_main_menu():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func change_to_meta_menu():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")

func on_continue_button_pressed():
    change_to_meta_menu()

func on_quit_button_pressed():
    change_to_main_menu()