extends CanvasLayer

@onready var seeds = $Seeds
@onready var slots = seeds.get_children()
@onready var selected_slot = 0

signal seed_type(value)

func _ready():
	for i in range(slots.size()):
		slots[i].connect("selected_slots", update_slots)
		slots[i].slot_index = i
		
	slots[selected_slot].visible = true
	seed_type.emit(selected_slot)
		
func update_slots(index): #Seeds Inventory Scroll visibilty
	selected_slot = index
	if selected_slot == 3:
		slots[selected_slot].visible = true
		slots[selected_slot -1].visible = false
		slots[0].visible = false
		seed_type.emit(selected_slot)
			
	elif selected_slot < 3:
		slots[selected_slot - 1].visible = false
		slots[selected_slot].visible = true
		slots[selected_slot + 1].visible = false
		seed_type.emit(selected_slot)

func seed_count():
	pass
