extends CharacterBody2D

var looking: String
var can_tanam = false
var can_attack = true
signal seeds_planting(type)

@onready var hitbox = $HitboxPivot/Hitbox
@onready var seeds_inven = preload("res://scenes/seeds_inven.tscn")

func _process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = direction * 150
	move_and_slide()
	
	if Input.is_action_pressed("tanam") and can_tanam:
		can_tanam = false
		$tanamCooldown.start()
		var seedType = plant_seeds()
		seeds_planting.emit(seedType)
	
	if Input.is_action_pressed("attack") and can_attack:
		can_attack = false
		$attackCooldown.start()
	
func _on_tanam_timeout(): #Tanam hotkey cooldown
	can_tanam = true

func _on_attack_timeout(): #Attack hotkey cooldown
	can_attack = true
	
func player_can_plant(status): #Signal from deathbody Area2D
	can_tanam = status
	
func plant_seeds(): #Start seeds timer
	pass
