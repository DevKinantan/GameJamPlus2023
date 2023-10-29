extends CharacterBody2D

#signal get_food(dish)

var order = null
var rng = RandomNumberGenerator.new()

func _ready():
	$OrderBubble.visible = false

var food_sprites = {
	"Fried Rice": preload("res://assets/sprite/Makanan/Fried Rice.png"),
	"Fried Shroom": preload("res://assets/sprite/Makanan/Fried Shroom.png"),
	"Seblak": preload("res://assets/sprite/Makanan/Seblak.png"),
	"Soda Nuklir" : preload("res://assets/sprite/Makanan/Soda.png"),
	"Steak Jamur" : preload("res://assets/sprite/Makanan/Mushroom Steak.png"),
	"Kopi" : preload("res://assets/sprite/Makanan/Kopi.png"),
	"Salad" : preload("res://assets/sprite/Makanan/Salad.png"),
	"Jamur Pizza" : preload("res://assets/sprite/Makanan/Mushroom Pizza.png"),
	"Mie Jamur" : preload("res://assets/sprite/Makanan/Mie Jamur.png"),
	"Jamur Sate" : preload("res://assets/sprite/Makanan/Sate Jamur.png"),
	"Jamur Cake" : preload("res://assets/sprite/Makanan/Cake Jamur.png"),
}

var dish = [
	"Fried Rice", "Fried Shroom", "Seblak", "Soda Nuklir", 
	"Steak Jamur", "Kopi", "Salad", "Jamur Pizza",
	"Mie Jamur", "Jamur Sate", "Jamur Cake"
	]


func order_food():
	var ranint = rng.randi_range(0, dish.size()-1)
	order = dish[ranint]
	$OrderBubble/Sprite2D.texture = food_sprites[order]
	$OrderBubble/Label.text = order
	$OrderBubble.visible = true

func leave():
	queue_free()


func get_order():
	return order
#	print("Send " + order + " from customer")
#	emit_signal("get_food", order)
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()


func _on_order_in_timeout():
	order_food()
