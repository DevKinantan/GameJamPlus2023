extends StaticBody2D

signal player_inside(status)

var canPlant : bool
@onready var player = get_parent().get_node("Player")
@onready var inven = get_parent().get_node("SeedsInven")
@onready var _harvest = preload("res://scenes/harvesting.tscn")
@onready var selected_seeds : String

func _ready():
	player.connect("_planting", plant_seeds)
	player.connect("seeds_planting", planted_seeds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(_body):
	canPlant = true
	player_inside.emit(canPlant)

func _on_area_2d_body_exited(_body):
	canPlant = false
	player_inside.emit(canPlant)
	
func planted_seeds(value):
	selected_seeds = value
	
func plant_seeds():
	call("call_mushroom")
	queue_free()

func call_mushroom():
	var harvest_mushroom = _harvest.instantiate()
	get_parent().add_child(harvest_mushroom)
	harvest_mushroom.global_position = global_position
	harvest_mushroom.plant_result = selected_seeds
	harvest_mushroom.connect("harvest_time", player.player_can_harvest)
	harvest_mushroom.connect("harvested_shroom", inven.harvest_yield)
