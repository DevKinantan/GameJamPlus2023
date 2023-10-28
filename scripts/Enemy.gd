extends CharacterBody2D

@export var death_body_scene = preload("res://scenes/death_enemy.tscn")
@export var hp = 3
@export var speed = 80.0
@export var knockback_power = 100.0

@onready var animationPlayer = $AnimationPlayer
@onready var idleSprite = $IdleSprite
@onready var walkingSprite = $WalkingSprite
@onready var deadSprite = $DeadSprite

@onready var detectionArea = $DetectionArea
@onready var wanderingTimer = $WanderingTimer

enum {
	IDLE,
	CHASING,
	DEAD,
	KNOCKBACK,
	WANDERING
}

var target = null
var state = IDLE
var is_facing_right = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		IDLE:
			idle_state()
		CHASING:
			chasing_state(delta)
		KNOCKBACK:
			knockback_state()
		WANDERING:
			wandering_state()


func chasing_state(delta):
	wanderingTimer.stop()
	set_flip_sprite(target.global_position.x > global_position.x)
	play_walking_animation()
		
	velocity = global_position.direction_to(target.global_position) * speed
	move_and_slide()


func idle_state():
	play_idle_animation()
	
	if wanderingTimer.is_stopped():
		wanderingTimer.start(3)


func knockback_state():
	velocity.x = move_toward(velocity.x, 0, 2)
	velocity.y = move_toward(velocity.y, 0, 2)
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		state = CHASING


func wandering_state():
	play_walking_animation()
	velocity.x = move_toward(velocity.x, 0, 2)
	velocity.y = move_toward(velocity.y, 0, 2)
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		state = IDLE


func _on_hurtbox_area_entered(area):
	if area.name == "PlayerHitbox":
		hp -= 1
		if hp == 0:
			state = DEAD
			play_dead_animation()
		else:
			velocity = global_position.direction_to(target.global_position) * -1.0
			velocity *= knockback_power
			state = KNOCKBACK


func play_idle_animation():
	idleSprite.visible = true
	walkingSprite.visible = false
	deadSprite.visible = false
	animationPlayer.play("Idle")


func play_walking_animation():
	idleSprite.visible = false
	walkingSprite.visible = true
	deadSprite.visible = false
	animationPlayer.play("Walking")


func play_dead_animation():
	idleSprite.visible = false
	walkingSprite.visible = false
	deadSprite.visible = true
	animationPlayer.play("Dead")


func spawn_death_body():
	var death_body_node = death_body_scene.instantiate()
	get_parent().add_child(death_body_node)
	death_body_node.global_position = global_position
	death_body_node.get_node("DeadSprite").flip_h = is_facing_right
	queue_free()


func set_flip_sprite(value):
	if value != is_facing_right:
		is_facing_right = value
		idleSprite.flip_h = is_facing_right
		walkingSprite.flip_h = is_facing_right
		deadSprite.flip_h = is_facing_right


func _on_detection_area_body_entered(body):
	if body.name == "Player" and state != DEAD:
		target = body
		detectionArea.scale *= 2
		state = CHASING


func _on_detection_area_body_exited(body):
	if body.name == "Player" and state != DEAD:
		target = null
		detectionArea.scale = Vector2(1.0, 1.0)
		state = IDLE


func _on_wandering_timer_timeout():
	var x = randi_range(-1, 1)
	var y = randi_range(-1, 1)
	var direction = Vector2(x, y)
	set_flip_sprite(x > 0)
	
	velocity = direction * 100
	state = WANDERING
