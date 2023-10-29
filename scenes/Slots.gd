extends Panel

@onready var slot_index
@onready var active_slot = 0
@onready var inven_length = get_parent().get_children().size()
@onready var scrollCooldown = get_owner().get_node("scrollCooldown")
@onready var backpack = get_owner().get_node("Backpack")
@onready var can_scroll = true

signal selected_slots(index)

func _ready():
	scrollCooldown.connect("timeout", scroll_timeout)
	
func _process(_delta):
	if Input.is_action_just_pressed("seedScrollUp") and can_scroll:
		backpack.play()
		can_scroll = false
		selected_slots_up()
		scrollCooldown.start()
	elif Input.is_action_just_pressed("seedScrollDown") and can_scroll:
		backpack.play()
		can_scroll = false
		selected_slots_down()
		scrollCooldown.start()

func selected_slots_up():
	active_slot = (active_slot + 1) % inven_length
	selected_slots.emit(active_slot)
	
func selected_slots_down():
	if active_slot == 0:
		active_slot = inven_length - 1
	else:
		active_slot -= 1
	selected_slots.emit(active_slot)

func scroll_timeout():
	can_scroll = true
