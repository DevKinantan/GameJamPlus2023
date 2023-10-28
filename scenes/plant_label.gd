extends Label

@onready var player = get_parent().get_parent().get_node("Player")
@onready var plant_timer

func _ready():
	player.connect("seeds_planting", label_timer)
	
func label_timer(time):
	plant_timer = time
	self.text = str(plant_timer)
	$duration.wait_time = plant_timer
	$duration.start()
	$countdown.start()
	
func _on_countdown_timeout():
	plant_timer -= 1
	if plant_timer == 0:
		queue_free()
