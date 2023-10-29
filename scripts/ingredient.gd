class_name Ingredient extends Node2D

#signal drag_mode(status)
#var draggable = false

var clone_path = preload("res://scenes/Ingredients/Core/cloned_ingredients.tscn")
var clone = null


#func _process(_delta):
#	if draggable:
#		global_position = get_global_mouse_position()


func set_drag_mode(drag_mode: bool):
	#draggable = drag_mode
	if drag_mode:
		clone = clone_path.instantiate()
		clone.changeSprite($Sprite2D.texture)
		get_tree().get_root().add_child(clone)
	#emit_signal("drag_mode", draggable)
	
	if not drag_mode:
		clone.queue_free()
		clone = null

@warning_ignore("native_method_override")
func get_class(): 
	return "Ingredient"


@warning_ignore("native_method_override")
func is_class(value):
	return value == "Ingredient"
