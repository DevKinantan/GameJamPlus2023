extends Node2D

#@export var can_drag = true
signal set_mixer(mixer, ingredients)
signal set_dish
signal set_order(order)
signal reset_food_pos

var picked_item = null
var picked_food = false

func _process(delta):
	global_position = get_global_mouse_position()

func _input(event):
	#if event is InputEventMouseButton:
	#	global_position = get_global_mouse_position()
	
	if event is InputEventMouseButton:		
		var mouse_collision = $Area2D
		
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			for area in mouse_collision.get_overlapping_areas():
				#if can_drag and area.get_parent().is_class("Ingredient"):
				if area.get_parent().is_class("Ingredient"):					
					print("Found " + area.get_parent().name)
					picked_item = area.get_parent()
					picked_item.set_drag_mode(true)
					$ClickSFX.play()
					#can_drag = false
					break
			
			for area in mouse_collision.get_overlapping_areas():
				if area.get_parent().is_in_group("Dish"):
					var dish = area.get_parent()
					if dish.get_node("Sprite2D").texture != null:
						emit_signal("set_dish")
						picked_food = true
						$ClickSFX.play()
						
						break
			
				#if area.is_in_group("Loot"):
				#	area.getLoot()
				#	break
					
		
		#if not can_drag and event.is_released() and picked_item != null:
		if event.is_released():
			if picked_item != null:
				picked_item.set_drag_mode(false)
				
				for area in mouse_collision.get_overlapping_areas():
					if area.get_parent().is_in_group("Mixer"):
						var mixer = area.get_parent()
						mixer.get_node("Sprite2D").texture = picked_item.get_node("Sprite2D").texture
						emit_signal("set_mixer", mixer.name, picked_item.name)
						$ClickSFX.play()
						break
				#can_drag = true
				picked_item = null
			
			if picked_food:
				for area in mouse_collision.get_overlapping_areas():
					if area.get_parent().is_in_group("Order"):
						emit_signal("set_order", area.get_parent().get_order())
						area.get_parent().leave()
						break
				emit_signal("reset_food_pos")
				picked_food = false
