extends CanvasLayer

signal transitioned_halfway
 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
 
func transition():
	(color_rect.material as ShaderMaterial).set_shader_parameter("percent", 0.0)
	color_rect.visible = true
	animation_player.play("default")
	await animation_player.animation_finished
	(color_rect.material as ShaderMaterial).set_shader_parameter("percent", 1.0)
	transitioned_halfway.emit()
	animation_player.play_backwards("default")
	await animation_player.animation_finished
	color_rect.visible = false
	(color_rect.material as ShaderMaterial).set_shader_parameter("percent", 0.0)
