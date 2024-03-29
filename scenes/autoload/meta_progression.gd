extends Node

const SAVE_FILE_PATH = "user://savegame.sav"

var save_data: Dictionary = {
    "lost_total": 0,
    "won_total": 0,
    "meta_upgrade_currency": 0,
    "meta_upgrades": {}
}


func _ready():
    GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
    load_file()

func get_currency() -> int:
    if FileAccess.file_exists(SAVE_FILE_PATH):
        load_file()
    else:
        return 0
    return save_data["meta_upgrade_currency"]

func get_quantity_of_meta_upgrade(upgrade_id: String) -> int:
    if not save_data["meta_upgrades"].has(upgrade_id):
        return 0
    return save_data["meta_upgrades"][upgrade_id]["quantity"]

func save_file():
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    file.store_var(save_data)
    file.close()


func load_file():
    if !FileAccess.file_exists(SAVE_FILE_PATH):
        return
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
    save_data = file.get_var()
    file.close()


func add_meta_upgrade(upgrade: MetaUpgrade):
    if not save_data["meta_upgrades"].has(upgrade.id):
        save_data["meta_upgrades"][upgrade.id] = {
            "quantity": 0
        }
    save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
    save_data["meta_upgrade_currency"] -= upgrade.experience_cost
    save_file()


func on_experience_vial_collected(amount: int):
    save_data["meta_upgrade_currency"] += amount
    save_file()