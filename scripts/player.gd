extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var next_animation = "Idle"
var dying = false;
var taking_damage = false;
var health = 100;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if not dying:
		if (Input.is_action_just_pressed("attack")):
			next_animation = "Attack"
			Attack()
			await animated_sprite.animation_finished
			next_animation = "Idle"
			
		if animated_sprite.animation == "GetDamage":
			direction = 0
			await animated_sprite.animation_finished
			next_animation = "Idle"
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			next_animation = "Jump"
			velocity.y = JUMP_VELOCITY

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction > 0:
		animated_sprite.flip_h = false
		
	if direction < 0:
		animated_sprite.flip_h = true
		
	if (is_on_floor() and next_animation != "Attack"):
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Walk")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	animated_sprite.play(next_animation)
	move_and_slide()
	
func Death() -> void:
	dying = true;
	animated_sprite.play("Death");
	GameManager.dying()
	await  animated_sprite.animation_finished
	dying = false

func take_damage(damage: int) -> void:
	if not taking_damage:
		health -= damage;
		if (health <= 0):
			Death()
		else:
			SetAnimation("GetDamage")
			taking_damage = true
			timer.start()

func SetAnimation(animation: String) -> void:
	if(animation == "Death"):
		next_animation = animation;
		
	elif(animation == "Damage"):
		next_animation = animation;
	
	if(animated_sprite.animation_finished):
		next_animation = animation;

func PlayAnimation() -> void:
	
	pass

func Attack()-> void:
	SetAnimation("FirstAttack")

func _on_timer_timeout() -> void:
	taking_damage = false;
