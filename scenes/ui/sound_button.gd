extends Button


func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	($RandomStreamPlayerComponent as RandomStreamPlayerComponent).play_random()
