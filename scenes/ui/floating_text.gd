extends Node2D
class_name FloatingText


func _ready():
    pass


func start(text: String):
    $Label.text = text


    var tween = create_tween()

    tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
    .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

    tween.set_parallel()

    tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4)\
    .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

    tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15)\
    .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT).set_delay(0.25)
    # tween color fade ffffff00
    tween.tween_property(self, "modulate", Color(1, 1, 1, 0), .15)\
    .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_delay(0.25)
    tween.chain()

    tween.tween_callback(queue_free)