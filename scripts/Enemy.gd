extends CharacterBody2D

@export var death_body_scene = preload("res://scenes/death_enemy.tscn")
@export var projectile_scene = preload("res://scenes/stump_projectile.tscn")
@export var hp = 3
@export var speed = 80.0
@export var knockback_power = 100.0
@export var push_power = 30.0
@export var drawback_power = 100.0
@export var have_charge_atk = false
@export var have_projectile_atk = false
@export var projectile_spread_angle = 10

@onready var animationPlayer = $AnimationPlayer
@onready var idleSprite = $IdleSprite
@onready var walkingSprite = $WalkingSprite
@onready var deadSprite = $DeadSprite

@onready var detectionArea = $DetectionArea
@onready var enemyHitboxCollision = $EnemyHitbox/CollisionShape2D
@onready var enemyHitbox = $EnemyHitbox
@onready var wanderingTimer = $WanderingTimer

var cooldownTimer = null
var attackSprite = null

enum {
	IDLE,
	CHASING,
	DEAD,
	KNOCKBACK,
	WANDERING,
	DRAWBACK,
	ATTACK
}

var target = null
var state = IDLE
var is_facing_right = false


func _ready():
	if have_projectile_atk:
		cooldownTimer = $CooldownTimer
		attackSprite = $AttackSprite


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
		DRAWBACK:
			drawback_state()
		ATTACK:
			attack_state()


func chasing_state(delta):
	wanderingTimer.stop()
	set_flip_sprite(target.global_position.x > global_position.x)
	play_walking_animation()

	velocity = global_position.direction_to(target.global_position) * speed
	move_and_slide()
	
	if have_projectile_atk and target != null:
		if cooldownTimer.is_stopped():
			cooldownTimer.start(2)


func idle_state():
	play_idle_animation()
	
	if wanderingTimer.is_stopped():
		wanderingTimer.start(3)
	
	if have_projectile_atk:
		cooldownTimer.stop()


func knockback_state():
	velocity.x = move_toward(velocity.x, 0, 2)
	velocity.y = move_toward(velocity.y, 0, 2)
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		state = CHASING


func drawback_state():
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


func attack_state():
	idleSprite.visible = false
	walkingSprite.visible = false
	deadSprite.visible = false
	attackSprite.visible = true

	animationPlayer.play("Attack")


func _on_hurtbox_area_entered(area):
	if area.name == "PlayerHitbox" and state != KNOCKBACK:
		hp -= 1
		if hp <= 0:
			if have_projectile_atk:
				cooldownTimer.stop()
			state = DEAD
			play_dead_animation()
		else:
			velocity = global_position.direction_to(target.global_position) * -1.0
			velocity *= knockback_power
			play_hit_animation()
			state = KNOCKBACK


func play_idle_animation():
	idleSprite.visible = true
	walkingSprite.visible = false
	deadSprite.visible = false
	
	if have_projectile_atk:
		attackSprite.visible = false

	animationPlayer.play("Idle")


func play_hit_animation():
	idleSprite.visible = true
	walkingSprite.visible = false
	deadSprite.visible = false
	
	if have_projectile_atk:
		attackSprite.visible = false

	animationPlayer.play("Hit")


func play_walking_animation():
	idleSprite.visible = false
	walkingSprite.visible = true
	deadSprite.visible = false
	
	if have_projectile_atk:
		attackSprite.visible = false

	animationPlayer.play("Walking")


func play_dead_animation():
	idleSprite.visible = false
	walkingSprite.visible = false
	deadSprite.visible = true
	
	if have_projectile_atk:
		attackSprite.visible = false

	animationPlayer.play("Dead")


func spawn_death_body():
	var death_body_node = death_body_scene.instantiate()
	death_body_node.position = position
	get_parent().add_child(death_body_node)
	death_body_node.get_node("DeadSprite").flip_h = is_facing_right
	death_body_node.connect("player_inside", $"../../Player".player_can_plant)
	queue_free()


func set_flip_sprite(value):
	if value != is_facing_right:
		is_facing_right = value
		idleSprite.flip_h = is_facing_right
		walkingSprite.flip_h = is_facing_right
		deadSprite.flip_h = is_facing_right
		
		if have_projectile_atk:
			attackSprite.flip_h = is_facing_right


func disable_enemy_hitbox():
	enemyHitboxCollision.disabled = true


func attack_finish():
	if target:
		var direction = global_position.direction_to(target.global_position)
		var angle = direction.angle()
		
		var projectile_node_1 = projectile_scene.instantiate()
		projectile_node_1.velocity = direction * projectile_node_1.speed
		projectile_node_1.rotation = angle
		
		var projectile_node_2 = projectile_scene.instantiate()
		var angle2 = angle + deg_to_rad(projectile_spread_angle)
		projectile_node_2.velocity = Vector2(cos(angle2), sin(angle2)) * projectile_node_2.speed
		projectile_node_2.rotation = angle2
		
		var projectile_node_3 = projectile_scene.instantiate()
		var angle3 = angle - deg_to_rad(projectile_spread_angle)
		projectile_node_3.velocity = Vector2(cos(angle3), sin(angle3)) * projectile_node_3.speed
		projectile_node_3.rotation = angle3
		
		add_child(projectile_node_1)
		add_child(projectile_node_2)
		add_child(projectile_node_3)
		attackSprite.visible = false
		state = CHASING
	else:
		attackSprite.visible = false
		state = IDLE


func _on_detection_area_body_entered(body):
	if body.name == "Player" and state != DEAD:
		target = body
		if not have_projectile_atk:
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
	
	velocity = direction * speed
	state = WANDERING


func _on_enemy_hitbox_area_entered(area):
	if area.name == "PlayerHurtbox":
		velocity = global_position.direction_to(target.global_position) * -1.0
		velocity *= drawback_power
		state = DRAWBACK


func _on_cooldown_timer_timeout():
	state = ATTACK
