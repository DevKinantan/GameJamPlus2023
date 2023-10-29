extends StaticBody2D

var death_body_scene = preload("res://scenes/death_enemy.tscn")
var hp = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hurtbox_area_entered(area):
	print(area.name)
	#spawn_death_body()
	hp -= 1
	if hp == 0:
		call_deferred("spawn_death_body")
		queue_free()


func spawn_death_body():
	var death_body_node = death_body_scene.instantiate()
	get_parent().add_child(death_body_node)
	death_body_node.global_position = global_position
	death_body_node.connect("player_inside", $"../Player".player_can_plant)
