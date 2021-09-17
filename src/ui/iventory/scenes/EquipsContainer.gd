extends BaseInventory

onready var slots = [
	$TopContainer/HeadSlot,
	$MidleContainer/OffhandSlot,
	$MidleContainer/ChestSlot,
	$MidleContainer/MainhandSlot,
	$BottomContainer/Accessory1Slot,
	$BottomContainer/FootSlot,
	$BottomContainer/Accessory2Slot
]
var slots_dictionary;

func _ready() -> void:
	._update_all_slots()

func _get_slot(index: int):
	return slots[index]
