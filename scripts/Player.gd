extends CharacterBody2D


enum {
	MOVE,
	ATTACK,
	KNOCKBACK,
	DASH,
	FREEZE,
	TANAM,
}

const SPEED = 100.0

@export var hp = 5

var is_facing_left = false
var state = MOVE
var enemies_on_area = false

@onready var animationPlayer = $AnimationPlayer
@onready var idleSprite = $IdleSprite
@onready var walkSprite = $WalkSprite
@onready var attackSprite = $AttackSprite
@onready var hitboxPivot = $HitboxPivot
@onready var hitbox = $HitboxPivot/PlayerHitbox
@onready var detectionArea = $DetectionArea
@onready var canvasAnimation = $CanvasLayer/AnimationPlayer

@onready var heartUI = $CanvasLayer/HeartUI/Heart


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			play_attack()
		KNOCKBACK:
			knockback_state()
		FREEZE:
			pass
		TANAM:
			tanam_benih()
	
	check_enemies_on_area()
	flip_sprite(velocity)
		


func move_state(delta):
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif direction.x or direction.y:
		play_walk()
		direction *= SPEED
		velocity = Vector2(direction.x, direction.y)

	else:
		play_idle()
		velocity *= delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func knockback_state():
	velocity.x = move_toward(velocity.x, 0, 2)
	velocity.y = move_toward(velocity.y, 0, 2)
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		state = MOVE


func play_walk():
	walkSprite.visible = true
	idleSprite.visible = false
	attackSprite.visible = false
	animationPlayer.play("WalkRight")


func play_idle():
	walkSprite.visible = false
	idleSprite.visible = true
	attackSprite.visible = false
	animationPlayer.play("Idle")


func play_hit_animation():
	walkSprite.visible = false
	idleSprite.visible = true
	attackSprite.visible = false
	animationPlayer.play("Hit")


func play_attack():
	walkSprite.visible = false
	idleSprite.visible = false
	attackSprite.visible = true
	animationPlayer.play("AttackRight")


func flip_sprite(direction):
	if enemies_on_area:
		is_facing_left = get_global_mouse_position().x < global_position.x
	elif direction.x and not enemies_on_area:
		is_facing_left = direction.x < 0
	
	idleSprite.flip_h = is_facing_left
	walkSprite.flip_h = is_facing_left
	attackSprite.flip_h = is_facing_left
	
	if is_facing_left:
		hitboxPivot.rotation_degrees = 180
	else:
		hitboxPivot.rotation_degrees = 0


func attack_animation_finish():
	state = MOVE


func check_enemies_on_area():
	var overlapping_area = detectionArea.get_overlapping_areas()
	enemies_on_area = false
	for area in overlapping_area:
		if area.name == "EnemyHurtbox":
			enemies_on_area = true
			break


func freeze_state():
	state = FREEZE


func go_back_and_heal():
	hp = 5
	heartUI.size.x =  hp * 32
	position = Vector2(460, 100)


func _on_player_hurtbox_area_entered(area):
	if area.name == "EnemyHitbox" and state != KNOCKBACK:
		hp -= 1
		if hp <= 0:
			heartUI.size.x -= 32
			canvasAnimation.play("FadeblackTransfer")
		else:
			velocity = global_position.direction_to(area.global_position) * -1.0
			velocity *= area.get_parent().push_power
			play_hit_animation()
			state = KNOCKBACK
			heartUI.size.x -= 32

	hitbox.monitorable = false

func tanam_benih():
	if Input.is_action_pressed("tanam"):
		print("wahoo")

