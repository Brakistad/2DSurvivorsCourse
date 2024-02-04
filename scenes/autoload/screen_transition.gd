extends CanvasLayer

signal transitioned_halfway
 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
 
func transition():
	$ColorRect.visible = true
	animation_player.play("default")
	await animation_player.animation_finished
	transitioned_halfway.emit()
	animation_player.play_backwards("default")
	await animation_player.animation_finished
	$ColorRect.visible = false
