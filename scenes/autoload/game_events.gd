extends Node


signal experience_vial_collected(number: float)
signal abiltiy_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

var last_scene: String = ""


func emit_experience_vial_collected(number: float):
    experience_vial_collected.emit(number)
    
    
func emit_abiltiy_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    abiltiy_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
    player_damaged.emit()

