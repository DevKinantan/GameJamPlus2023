extends StaticBody2D

@export var have_seed = false
@export var harvestable = false

signal player_inside(status)

var canPlant : bool
@onready var player = get_parent().get_parent().get_node("Player")
@onready var inven = player.get_node("SeedsInven")
@onready var _harvesst = preload("res://scenes/harvesting.tscn")
@onready var selected_seeds

@onready var benih = $Benih
@onready var jamur = $Jamur

@export var countdown = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	#player.connect("_planting", plant_seeds)
	player.connect("seeds_planting", planted_seeds)


func _on_area_2d_body_entered(_body):
	canPlant = true
	player_inside.emit(canPlant)

func _on_area_2d_body_exited(_body):
	canPlant = false
	player_inside.emit(canPlant)


func planted_seeds(value):
	if not have_seed:
		selected_seeds = TimeInven.seed_slot
		TimeInven.mushroom_seed[selected_seeds] -= 1
		benih.visible = true
		benih.get_node(str(selected_seeds)).visible = true
		have_seed = true
		
		$Start.start(countdown)
		$Countdown.start()
		$Label.visible = true
		
		print("current seeds")
		print(TimeInven.mushroom_seed)
	
	elif harvestable:
		TimeInven.mushroom_stock[selected_seeds] += 3
		print("current stock")
		print(TimeInven.mushroom_stock)
		queue_free()
	
#	elif have_seed:
#		benih.visible = false
#		jamur.visible = true
#		jamur.get_node(str(selected_seeds)).visible = true
#		harvestable = true
	
	
	
	
#func plant_seeds():
#	call("call_mushroom")
#	queue_free()

#func call_mushroom():
#	var harvest_mushroom = _harvest.instantiate()
#	get_parent().add_child(harvest_mushroom)
#	harvest_mushroom.global_position = global_position
#	harvest_mushroom.plant_result = selected_seeds
#	harvest_mushroom.connect("harvest_time", player.player_can_harvest)
#	harvest_mushroom.connect("harvested_shroom", inven.harvest_yield)


func _on_start_timeout():
	benih.visible = false
	jamur.visible = true
	jamur.get_node(str(selected_seeds)).visible = true
	harvestable = true


func _on_countdown_timeout():
	if countdown <= 0:
		$Label.text = "Q to harvest"
		$Countdown.stop()
	else:
		$Label.text = str(countdown)
		countdown -= 1
