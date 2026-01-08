extends CharacterBody2D

enum State { Idle, Attack, Damage, Death }

const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var next_animation = "Idle"
var is_dead = false;
var i_frames = false;
var health = 100;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Iframes
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if(is_dead):
		return;
	var direction := Input.get_axis("move_left", "move_right")
	
	Attack()
		 
	if animation_player.current_animation == "GetDamage":
		direction = 0
		await animation_player.animation_finished
		next_animation = "Idle"
		
	player_jump(delta)
	
	if direction > 0:
		animated_sprite.flip_h = false;
		
	if direction < 0:
		animated_sprite.flip_h = true;
		
	if (is_on_floor() and next_animation != "Attack" and next_animation != "Death"):
		if direction == 0:
			animation_player.play("Idle");
		else:
			animation_player.play("Walk");
	if direction:
		velocity.x = direction * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);

	move_and_slide()
	
func Death() -> void:
	is_dead = true;
	next_animation = "Death";
	animation_player.play("Death");
	await animation_player.animation_finished;
	

func take_damage() -> void:
	if not i_frames:
		next_animation = "GetDamage";
		animation_player.play("GetDamage");
		health -= 20;
		i_frames = true;
		timer.start();

func Attack()-> void:
	if Input.is_action_just_pressed("Attack"):
		next_animation = "Attack";
		animation_player.play("FirstAttack");
		await animation_player.animation_finished;
		next_animation = "Idle";

		velocity.x = move_toward(velocity.x, 0, SPEED)
	animated_sprite.play(next_animation)
	move_and_slide()
	
func setAction() -> void:
	if (Input.is_action_just_pressed("attack")):
		attack()	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		next_animation = "Jump"
		velocity.y = JUMP_VELOCITY
		
func setDirection() -> void:
	if animated_sprite.animation == "GetDamage":
		direction = 0
		await animated_sprite.animation_finished
		next_animation = "Idle"
	else:
		direction = Input.get_axis("move_left", "move_right")

func setState(value: State):
	state = value
	
func setAnimation() -> void:
	if(state == State.Death):
		next_animation = "Death";
		
	elif(state == State.Damage):
		next_animation = "Damage";
	
	#if(animated_sprite.animation_finished):
		#next_animation = animation;
		
func takeDamage(damage: int) -> void:
	if not taking_damage:
		health -= damage;
		if (health <= 0):
			death()
		else:
			setState(State.Damage)
			taking_damage = true
			timer.start()

func playAnimation() -> void:
	
	pass

func attack()-> void:
	setState(State.Attack)


func death() -> void:
	dying = true;
	animated_sprite.play("Death");
	GameManager.dying()
	await  animated_sprite.animation_finished
	dying = false
	
func _on_timer_timeout() -> void:

	i_frames = false;

func player_jump(delta):
	if Input.is_action_just_pressed("Jump"):
		next_animation = 'Jump'
		velocity.y = JUMP_VELOCITY
	if not is_on_floor() and next_animation == 'Jump':
		velocity += get_gravity() * delta
