extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var farm = preload("res://scenes/farm.tscn")
var masak = preload("res://scenes/restaurant.tscn")


func _on_button_pressed():
	get_parent().add_child(farm.instantiate())
	visible = false


func _on_button_2_pressed():
	get_parent().add_child(masak.instantiate())
	visible = false
