extends CharacterBody2D


@export var speed = 200.0
@export var push_power = 50.0

@onready var origin_location = global_position


func _physics_process(_delta):
	if global_position.distance_to(origin_location) > 200.0:
		queue_free()
	else:
		velocity.x = move_toward(velocity.x, 0, 0)
		velocity.y = move_toward(velocity.y, 0, 0)

		move_and_slide()


func _on_enemy_hitbox_area_entered(area):
	if area.name == "PlayerHurtbox":
		queue_free()
