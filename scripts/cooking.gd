extends Node2D

signal game_started
signal customer_left

var mixer1 = null;
var mixer2 = null;
var mixer3 = "Kuali";
var food = null;

var draggingFood = false;

var mixer3Index = 0;

var recipes = {
	"Normal + Kuali": "Fried Rice",
	"Normal + Rotten + Kuali": "Fried Shroom",
	"Rotten + Doom + Kuali": "Seblak",
	"Doom + Blender": "Soda Nuklir",
	"Normal + Grill": "Steak Jamur",
	"Crown + Blender": "Kopi",
	"Crown + Normal + Kuali": "Salad",
	"Rotten + Doom + Oven": "Jamur Pizza",
	"Doom + Normal + Kuali": "Mie Jamur",
	"Rotten + Normal + Grill": "Jamur Sate",
	"Crown + Oven": "Jamur Cake",
}

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

var mixer3_sprites = {
	"Kuali": preload("res://assets/sprite/AlatMasak/Kuali.png"),
	"Grill": preload("res://assets/sprite/AlatMasak/grill.png"),
	"Oven": preload("res://assets/sprite/AlatMasak/oven.png"),
	"Blender": preload("res://assets/sprite/AlatMasak/blender.png")
}

var mixer3_cycles = ["Kuali", "Grill", "Oven", "Blender"]

#var customer_scene = preload("res://scenes/Customer/customer.tscn")

@onready var mixer1_sprite = get_node("CookPanel/Mixer1/Sprite2D")
@onready var mixer2_sprite = get_node("CookPanel/Mixer2/Sprite2D")
@onready var mixer3_sprite = get_node("CookPanel/Mixer3/Sprite2D")
@onready var food_sprite = get_node("CookPanel/Food/Sprite2D")
@onready var cook_button = get_node("CookPanel/CookBtn")

@onready var originFoodPos = $CookPanel/Food.global_position;

# Called when the node enters the scene tree for the first time.
func _ready():
	$CookPanel.position.y = 300
	$CookPanel.visible = false
	print(originFoodPos)

func _process(delta):
	if draggingFood:
		$CookPanel/Food.global_position = get_global_mouse_position()


func clear_mixer():
	mixer1 = null
	mixer1_sprite.texture = null
	
	mixer2 = null
	mixer2_sprite.texture = null


func canMakeDish(ingredients: Array) -> String:
	var num_ingredients = ingredients.size()
	var ingredient_str = ""
	
	if num_ingredients == 2:
		ingredient_str = ingredients[0] + " + " + ingredients[1]
		if recipes.has(ingredient_str):
			return recipes[ingredient_str]
	
	elif num_ingredients == 3:
		ingredient_str = ingredients[0] + " + " + ingredients[1] + " + " + ingredients[2]
		if recipes.has(ingredient_str):
			return recipes[ingredient_str]
		
		ingredient_str = ingredients[1] + " + " + ingredients[0] + " + " + ingredients[2]
		if recipes.has(ingredient_str):
			return recipes[ingredient_str]
	
	return "Unknown Dish"


func cook_food():
	var myIngredients = null
	
	if mixer1 and mixer2:
		myIngredients = [mixer1, mixer2, mixer3]
	elif mixer1 and not mixer2:
		myIngredients = [mixer1, mixer3]
	elif not mixer1 and mixer2:
		myIngredients = [mixer2, mixer3]
	else:
		return
	
	var dish = canMakeDish(myIngredients)
	clear_mixer()
	
	if dish == "Unknown Dish":
		$DenySFX.play()
		return
	
	food_sprite.texture = food_sprites[dish]
	food = dish
	cook_button.visible = false
	$CookSFX.play()


#func spawn_customer():
#	var customer = customer_scene.instantiate()
##	get_tree().get_root().add_child(customer)
#	return customer


func cycle_mixer3(increment: int):
	mixer3Index += increment
	
	if mixer3Index < 0:
		mixer3Index = 3
	elif mixer3Index > 3:
		mixer3Index = 0
	
	mixer3_sprite.texture = mixer3_sprites[mixer3_cycles[mixer3Index]]
	mixer3 = mixer3_cycles[mixer3Index]


func _on_user_pointer_set_mixer(mixer, ingredients):
	if mixer == "Mixer1":
		mixer1 = ingredients
	elif mixer == "Mixer2":
		mixer2 = ingredients


func _on_cook_btn_pressed():
	cook_food()


func _on_up_btn_pressed():
	cycle_mixer3(-1)
	$ClickSFX.play()


func _on_down_btn_pressed():
	cycle_mixer3(1)
	$ClickSFX.play()


func _on_start_btn_pressed():
	$CookPanel.visible = true
	$StartPanel.visible = false
	$CookPanel.position.y = 164
	emit_signal("game_started")
	$ClickSFX.play()


func _on_user_pointer_set_dish():
	draggingFood = true


func _on_user_pointer_set_order(order):
	if order == food:
		print("U right")
		$ConfirmSFX.play()
	else:
		print("U Wrong")
		$DenySFX.play()
	
	cook_button.visible = true
	food_sprite.texture = null
	emit_signal("customer_left")


func _on_user_pointer_reset_food_pos():
	draggingFood = false
	$CookPanel/Food.global_position.x = originFoodPos.x
	$CookPanel/Food.global_position.y = originFoodPos.y - 4	
