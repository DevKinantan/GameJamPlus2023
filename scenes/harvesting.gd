extends StaticBody2D

signal harvest_time(status)

@onready var canHarvest : bool
@export var plant_result : String

func _process(_delta):
	
	call("take_result")
	
	if Input.is_action_pressed("Interact") and canHarvest:
		
		queue_free()

func take_result():
	if plant_result == "Reg":
		$Regular.visible = true
	elif plant_result == "Doom":
		$Doom.visible = true
	elif plant_result == "Dia":
		$Diamond.visible = true
	else:
		$Rotten.visible = true

func _on_area_2d_body_entered(_body):
	canHarvest = true
	harvest_time.emit(canHarvest)

func _on_area_2d_body_exited(_body):
	canHarvest = false
	harvest_time.emit(canHarvest)


