extends CharacterBody2D

enum State { IDLE, WALK, RUN, ATTACK, JUMP, DAMAGE, DEATH }

const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var next_animation = "Idle"
var i_frames = false;
var health = 100;
var taking_damage = false;
var direction = 0;
var state = State.IDLE
var combo = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Iframes
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	update_direction()
	update_sprite()
	handle_actions()
	update_animation()
	apply_movement(delta)
	
func update_direction() -> void:
	if animated_sprite.animation != "GetDamage":
		direction = Input.get_axis("move_left", "move_right")
	
func update_sprite() -> void:
	if direction > 0:
		animated_sprite.flip_h = false;
		
	if direction < 0:
		animated_sprite.flip_h = true;	
	
func handle_actions() -> void:
	if (Input.is_action_just_pressed("attack")):
		attack()	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		setState(State.JUMP)
		velocity.y = JUMP_VELOCITY
	
func update_animation() -> void:
	if(state == State.DEATH):
		next_animation = "Death";
		
	elif(state == State.DAMAGE):
		next_animation = "Damage";
	
	#if(animated_sprite.animation_finished):
		#next_animation = animation;	
	
func apply_movement(delta: float) -> void:
	
	if (is_on_floor()):
		if direction == 0:
			animation_player.play("Idle");
		else:
			animation_player.play("Walk");
		
	if direction:
		velocity.x = direction * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	move_and_slide()
	
func setState(value: State):
	state = value
	update_animation()
	
func playAnimation() -> void:
	
	pass
	
func death() -> void:
	setState(State.DEATH)
	
func take_damage(damage: int) -> void:
	if not state == State.DAMAGE:
		health -= damage;
		if (health <= 0):
			death()
		else:
			setState(State.DAMAGE)
			taking_damage = true
			timer.start()
	
func attack()-> void:
	combo += 1
	setState(State.ATTACK)
	
func _on_timer_timeout() -> void:
	i_frames = false;
	
func player_jump(delta):
	if Input.is_action_just_pressed("Jump"):
		next_animation = 'Jump'
		velocity.y = JUMP_VELOCITY
	if not is_on_floor() and next_animation == 'Jump':
		velocity += get_gravity() * delta

	taking_damage = false;
