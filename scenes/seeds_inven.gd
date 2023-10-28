extends CanvasLayer

@onready var seeds = $Seeds
@onready var slots = seeds.get_children()
@onready var selected_slot = 0

func _ready():
	for i in range(slots.size()):
		slots[i].connect("selected_slots", update_slots)
		slots[i].slot_index = i
		
	slots[selected_slot].visible = true
		
func update_slots(index): #Seeds Inventory Scroll visibilty
		selected_slot = index
		if selected_slot == 3:
			slots[selected_slot].visible = true
			slots[selected_slot -1].visible = false
			slots[0].visible = false
			
		elif selected_slot < 3:
			slots[selected_slot - 1].visible = false
			slots[selected_slot].visible = true
			slots[selected_slot + 1].visible = false
		
		print(selected_slot)

func active_slots():
	pass
