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

func harvest_yield(seeds):
	if seeds == "Reg":
		$Yield/Reg.visible = true
		$Yield/Reg/Label.text = "x" + str(Global.reg_shroom)
	elif seeds == "Doom":
		$Yield/Doom.visible = true
		$Yield/Doom/Label2.text = "x" + str(Global.doom_shroom)
	elif seeds == "Dia":
		$Yield/Dia.visible = true
		$Yield/Dia/Label3.text = "x" + str(Global.dia_shroom)
	else:
		$Yield/Rot.visible = true
		$Yield/Rot/Label4.text = "x" + str(Global.rotten_shroom)
