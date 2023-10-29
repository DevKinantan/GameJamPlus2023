extends Node2D


@onready var enemiesLocation = $EnemiesLocation

var ghoul_scene = preload("res://scenes/ghoul.tscn")
var stump_scene = preload("res://scenes/stump.tscn")
var pig_scene = preload("res://scenes/pig.tscn")
var brute_scene = preload("res://scenes/brute.tscn")

var index_start = 0

var ghoul_loc = [
	Vector2(2098, 819),
	Vector2(2222, 815),
	Vector2(1558, 795),
	Vector2(1484, 709),
	Vector2(459, 1202),
	Vector2(174, 783),
	Vector2(518, 590),
	Vector2(1019, 1181),
]

var stump_loc = [
	Vector2(791, 781),
	Vector2(2012, 1095),
	Vector2(2068, 1221),
	Vector2(1513, 1535),
]

var pig_loc = [
	Vector2(1098, 1452),
	Vector2(1006, 512),
]

var brute_loc = [
	Vector2(2162, 857),
	Vector2(1463, 788),
	Vector2(1286, 1162),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_monster()
	#for child_node in  enemiesLocation.get_children():
	#	if child_node is CharacterBody2D:
	#		print(child_node.name.split("_"))
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_monster():
	clear_monster()
	clear_dead_body()

	for idx in range(index_start, len(ghoul_loc), 2):
		var instance = ghoul_scene.instantiate()
		instance.position = ghoul_loc[idx]
		enemiesLocation.add_child(instance)
		
	for idx in range(index_start, len(stump_loc), 2):
		var instance = stump_scene.instantiate()
		instance.position = stump_loc[idx]
		enemiesLocation.add_child(instance)
		
	for idx in range(index_start, len(pig_loc), 2):
		var instance = pig_scene.instantiate()
		instance.position = pig_loc[idx]
		enemiesLocation.add_child(instance)
		
	for idx in range(index_start, len(brute_loc), 2):
		var instance = brute_scene.instantiate()
		instance.position = brute_loc[idx]
		enemiesLocation.add_child(instance)
	
	index_start = int(not index_start)


func clear_monster():
	for child_node in  enemiesLocation.get_children():
		if child_node is CharacterBody2D:
			child_node.queue_free()


func clear_dead_body():
	for child_node in  enemiesLocation.get_children():
		if child_node is StaticBody2D:
			if not child_node.have_seed:
				child_node.queue_free()


func _on_button_pressed():
	clear_monster()


func _on_button_2_pressed():
	spawn_monster()
