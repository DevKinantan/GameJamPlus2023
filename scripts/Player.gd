extends CharacterBody2D


enum {
	MOVE,
	ATTACK,
	TANAM,
}

const SPEED = 100.0

var is_facing_left = false
var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var idleSprite = $IdleSprite
@onready var walkSprite = $WalkSprite
@onready var attackSprite = $AttackSprite
@onready var hitboxPivot = $HitboxPivot
@onready var hitbox = $HitboxPivot/Hitbox


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			play_attack()
		TANAM:
			tanam_benih()


func move_state(delta):
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif direction.x or direction.y:
		play_walk()
		direction *= SPEED
		velocity = Vector2(direction.x, direction.y)
		if direction.x:
			if (direction.x < 0 and not is_facing_left) or (direction.x > 0 and is_facing_left):
				flip_sprite()
	else:
		play_idle()
		velocity *= delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


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


func play_attack():
	walkSprite.visible = false
	idleSprite.visible = false
	attackSprite.visible = true
	hitbox.monitorable = true
	animationPlayer.play("AttackRight")


func flip_sprite():
	is_facing_left = not is_facing_left
	idleSprite.flip_h = is_facing_left
	walkSprite.flip_h = is_facing_left
	attackSprite.flip_h = is_facing_left
	
	if is_facing_left:
		hitboxPivot.rotation_degrees = 180
	else:
		hitboxPivot.rotation_degrees = 0


func attack_animation_finish():
	state = MOVE
	hitbox.monitorable = false

func tanam_benih():
	if Input.is_action_pressed("tanam"):
		print("wahoo")


