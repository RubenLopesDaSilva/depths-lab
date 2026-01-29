extends CharacterBody2D

enum State { IDLE, WALK, JUMP, Fall, ATTACK, DAMAGE, DEATH }

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var state = State.IDLE
var health = 100;
var direction = 0;
var attack_combo = 0
var vulnerable = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Iframes
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	update_direction()
	update_sprite()
	handle_actions()
	apply_movement(delta)
	
func update_direction() -> void:
	if state != State.DAMAGE && state != State.DEATH:
		direction = Input.get_axis("move_left", "move_right")
	
func update_sprite() -> void:
	if direction > 0:
		animated_sprite.flip_h = false;
		
	if direction < 0:
		animated_sprite.flip_h = true;	
	
func handle_actions() -> void:
	if state == State.DEATH:
		return
	if (Input.is_action_just_pressed("attack")):
		attack()	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_state(State.JUMP)
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		set_state(State.Fall)
	
func apply_movement(delta: float) -> void:
	if state == State.DEATH:
		velocity.x = move_toward(velocity.x, 0, SPEED / 30)
	else:
		if (is_on_floor()):
			if direction == 0:
				set_state(State.IDLE)
			else:
				set_state(State.WALK)
		
		if direction:
			velocity.x = direction * SPEED;
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED);
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	move_and_slide()
	
func set_state(value: State) -> void:
	#bool objection
	if state == value:
		return
	if  state == State.DAMAGE && value != State.DEATH :
		return
	if  state == State.JUMP && (value != State.DEATH && value != State.DAMAGE) :
		return
	if state == State.ATTACK && (value != State.DEATH && value != State.DAMAGE) :
		return
	state = value
	play_animation()
	
func reset_state():
	state = State.IDLE
	play_animation()
	
func play_animation() -> void:
	if state == State.IDLE:
		animation_player.play("Idle")
	elif state == State.WALK:
		animation_player.play("Walk")
	elif state == State.JUMP:
		animation_player.play("Jump")
		await animation_player.animation_finished
		reset_state()
	elif state == State.Fall:
		animation_player.play("Fall")
	elif state == State.ATTACK:
		if attack_combo == 1:
			animation_player.play("FirstAttack")
		else:
			animation_player.play("SecondAttack")
		await animation_player.animation_finished
		reset_state()
		attack_combo = 0
		print("attack finished")
	elif state == State.DAMAGE:
		animation_player.play("GetDamage")
		await animation_player.animation_finished
		reset_state()
	elif state == State.DEATH:
		animation_player.play("Death")
		GameManager.dying()
  	
func attack()-> void:
	attack_combo += 1
	set_state(State.ATTACK)
	
func take_damage(damage: int) -> void:
	if vulnerable && state != State.DEATH:
		health -= damage;
		if (health <= 0):
			death()
		else:
			set_state(State.DAMAGE)
			vulnerable = false
			timer.start()
	print(health)
	
func death() -> void:
	set_state(State.DEATH)
	
func _on_timer_timeout() -> void:
	vulnerable = true
	
