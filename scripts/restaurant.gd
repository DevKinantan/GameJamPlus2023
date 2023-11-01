extends Node2D

var rng = RandomNumberGenerator.new()
var spawning = true

var customer_scene = preload("res://scenes/Customer/customer.tscn")

@export var timer = 120
@export var customer_waiting = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerText.text = "Timer: " + str(timer)
	$TimerText.visible = false
	
	var camera = $Player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 426
	camera.limit_bottom = 240
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_customer():
	if not spawning:
		return
	
	var ranint = 5
	
	if customer_waiting < 3:
		customer_waiting += 1
#		var customer = $Cooking.spawn_customer()
		var customer = customer_scene.instantiate()
		
		while true:
			ranint = rng.randi_range(0, $SpawnPositions.get_child_count()-1)
			var spawnPos = $SpawnPositions.get_child(ranint)
			print("Spawn child count: " + str(spawnPos.get_child_count()))
			if spawnPos.get_child_count() == 0:
				spawnPos.add_child(customer)
				break
		customer.global_position = $SpawnPositions.get_child(ranint).position
	
	ranint = rng.randi_range(5, 10)
	$SpawnTimer.start(ranint)

func _on_cooking_game_started():
	$SpawnTimer.start(2)
	
	$TimerText.visible = true
	$CountdownTimer.start()


func _on_countdown_timer_timeout():
	timer -= 1
	$TimerText.text = "Timer: " + str(timer)
	if timer < 1:
		print("Timeout")
		spawning = false
		$CountdownTimer.stop()


func _on_spawn_timer_timeout():
	spawn_customer()


func _on_cooking_customer_left():
	customer_waiting -= 1
	if customer_waiting == 0 and timer == 0:
		$FinishPanel.visible = true
		$TimerText.visible = false
		$FinishSFX.play()
		$Cooking.queue_free()


func _on_button_pressed():
	get_parent().get_node("TitleScreen").visible = true
	queue_free()
