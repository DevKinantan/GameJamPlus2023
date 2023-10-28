extends StaticBody2D

signal player_inside(status)
var canPlant : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(_body):
	canPlant = true
	player_inside.emit(canPlant)

func _on_area_2d_body_exited(_body):
	canPlant = false
	player_inside.emit(canPlant)
	

