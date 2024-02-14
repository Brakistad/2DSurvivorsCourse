extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
    make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    global_position = global_position.lerp(aquire_target(), 1.0 - exp(-delta*20))


func aquire_target_old():
    var target_position = Vector2.ZERO
    var player_nodes = get_tree().get_nodes_in_group("player")
    if player_nodes.size() > 0:
        var player = player_nodes[0] as Node2D
        target_position = player.global_position
    return target_position

func aquire_target():
    var target_position = Vector2.ZERO
    var player_nodes = get_tree().get_nodes_in_group("player")
    if player_nodes.size() > 1:
        var player1 = player_nodes[0] as Node2D
        var player2 = player_nodes[1] as Node2D
        target_position = (player1.global_position + player2.global_position) / 2
    elif player_nodes.size() > 0:
        var player = player_nodes[0] as Node2D
        target_position = player.global_position
    return target_position