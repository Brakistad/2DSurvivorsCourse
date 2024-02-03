extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 1


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	var total_experience = current_experience + number
	while total_experience >= target_experience:
		total_experience -= target_experience
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		level_up.emit(current_level)
	current_experience = total_experience
	experience_updated.emit(current_experience, target_experience)


func on_experience_vial_collected(number: float):
	increment_experience(number)
