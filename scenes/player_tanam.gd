extends CharacterBody2D

var looking: String
var can_tanam = false
var can_attack = true
var seed_type
var is_planting = false
var area_checker : bool
var harvest_area : bool
var can_harvest = false

signal seeds_planting(type)
signal _planting()
signal _harvesting()

@onready var hitbox = $HitboxPivot/Hitbox
@onready var seeds_inven = preload("res://scenes/seeds_inven.gd")
@onready var seedType = get_parent().get_node("SeedsInven")


func _ready():
	seedType.connect("seed_type", plant_seeds)
	$TanamPrompt.visible = false
	$HarvestPrompt.visible = false
	
func _process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = direction * 150
	move_and_slide()
	
	if can_tanam == true:
		$TanamPrompt.visible = true
		$TanamPrompt/Tanam.visible = true
	else:
		$TanamPrompt.visible = false
		$TanamPrompt/Tanam.visible = false
		
	if can_harvest == true:
		$HarvestPrompt.visible = true
		$HarvestPrompt/Harvest.visible = true
	else:
		$HarvestPrompt.visible = false
		$HarvestPrompt/Harvest.visible = false
		
	if Input.is_action_pressed("Interact") and can_tanam:
		can_tanam = false
		seeds_planting.emit(seed_type)
		_planting.emit()
		$tanamCooldown.start()
		
	if Input.is_action_pressed("Interact") and can_harvest:
		can_harvest = false
		_harvesting.emit()
		$harvestCooldown.start()
	
	if Input.is_action_pressed("attack") and can_attack:
		can_attack = false
		$attackCooldown.start()
	
func _on_tanam_timeout(): #Tanam hotkey cooldown
	if area_checker == false:
		can_tanam = false
	else:
		can_tanam = true

func _on_attack_timeout(): #Attack hotkey cooldown
	can_attack = true
	
func player_can_plant(status): #Signal from deathbody Area2D
	can_tanam = status
	area_checker = can_tanam
	
func plant_seeds(value): #Seeds type
	if value == 0:
		seed_type = "Reg"
	elif value == 1:
		seed_type = "Doom"
	elif value == 2:
		seed_type = "Dia"
	else:
		seed_type = "Rot"
		
func player_can_harvest(status):
	can_harvest = status
	harvest_area = can_harvest
		
func _on_harvest_cooldown_timeout():
	if harvest_area == false:
		can_harvest = false
	else:
		can_harvest = true
