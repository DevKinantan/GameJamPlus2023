extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = $Player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 426
	camera.limit_bottom = 240
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cooking_game_started():
	var customer = $Cooking.spawn_customer()
	var ranint = rng.randi_range(0, $SpawnPositions.get_child_count()-1)
	
	customer.global_position = $SpawnPositions.get_child(ranint).position
