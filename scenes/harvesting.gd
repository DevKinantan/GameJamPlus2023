extends StaticBody2D

signal harvest_time(status)
signal harvested_shroom(seeds)

@onready var canHarvest : bool
@onready var shroom_yield = 3
@export var plant_result : String

func _process(_delta):
	
	call("take_result")
	
	if Input.is_action_pressed("Interact") and canHarvest:
		_add_shroom()
		harvested_shroom.emit(plant_result)
		queue_free()

func _add_shroom():
	if plant_result == "Reg":
		Global.reg_shroom += shroom_yield
	elif plant_result == "Doom":
		Global.doom_shroom += shroom_yield
	elif plant_result == "Dia":
		Global.dia_shroom += shroom_yield
	else:
		Global.rotten_shroom += shroom_yield
	

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


