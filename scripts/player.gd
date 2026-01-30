extends CharacterBody2D

enum State { IDLE, WALK, JUMP, FALL, LAND, ATTACK, DAMAGE, DEATH }

enum AttackState { NONE, FIRST, SECOND, DISABLE }

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var state = State.IDLE
var attack_state = AttackState.FIRST
var health = 100
var notOnFloor = false
var direction = 0
var vulnerable = true
var animationFlag = 0
var close = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vulnerableTimer: Timer = $Iframes
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
		notOnFloor = true
		set_state(State.FALL)
	elif notOnFloor:
		notOnFloor = false
		set_state(State.LAND)
	
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
	
func set_state(value: State, objection: bool = false, play: bool = true) -> void:
	if(not objection):
		if state == value:
			return
		if state == State.LAND && (value == State.IDLE || value == State.WALK) :
			return
		if  state == State.DAMAGE && value != State.DEATH :
			return
		if  state == State.JUMP && (value != State.DEATH && value != State.DAMAGE) :
			return
		if state == State.ATTACK && (value != State.DEATH && value != State.DAMAGE) :
			return
	state = value
	if	play:
		play_animation()
	
func set_attack_state(value: AttackState) -> void:
	if state != State.ATTACK:
		return
	if value == attack_state:
		return
	attack_state = value
	play_animation()
	
func play_animation() -> void:
	if state == State.IDLE:
		play_idle()
	elif state == State.WALK:
		play_walk()
	elif state == State.JUMP:
		play_jump()
	elif state == State.FALL:
		play_fall()
	elif state == State.LAND:
		play_land()
	elif state == State.ATTACK:
		play_attack()
	elif state == State.DAMAGE:
		play_damage()
	elif state == State.DEATH:
		play_death()
	
func play_idle() -> void:
	animation_player.play("Idle")
	
func play_walk() -> void:
	animation_player.play("Walk")
	
func play_jump() -> void:
	animation_player.play("Jump")
	if await animation_finished_correctly():
		set_state(State.IDLE, true)
	
func play_fall() -> void:
	animation_player.play("Fall")
	
func play_land() -> void:
	animation_player.play("Land")
	if await animation_finished_correctly():
		set_state(State.IDLE, true)
	
func play_attack() -> void:
	if attack_state == AttackState.FIRST:
		await delay(0.5)
		close = true
		if attack_state == AttackState.FIRST:
			animation_player.play("FirstAttack")
	elif attack_state == AttackState.SECOND:
		animation_player.play("SecondAttack")
	if	await animation_finished_correctly(): 
		set_state(State.IDLE, true)
	close = false
	attack_state = AttackState.DISABLE
	await delay(0.2)
	attack_state = AttackState.NONE
	
func play_damage() -> void:
	animation_player.play("GetDamage")
	if await animation_finished_correctly():
		set_state(State.IDLE, true)

func play_death() -> void:
	animation_player.play("Death")
	GameManager.dying()	

func attack()-> void:
	if attack_state == AttackState.DISABLE:
		return
	if close:
		return
	set_state(State.ATTACK, false, false)
	if attack_state == AttackState.NONE:
		set_attack_state(AttackState.FIRST)
	elif attack_state == AttackState.FIRST:
		set_attack_state( AttackState.SECOND)
	
func take_damage(damage: int) -> void:
	if vulnerable && state != State.DEATH:
		health -= damage;
		if (health <= 0):
			death()
		else:
			set_state(State.DAMAGE)
			vulnerable = false
			vulnerableTimer.start()
	print(health)
	
func death() -> void:
	set_state(State.DEATH)
	
func animation_finished_correctly() -> bool:
	animationFlag += 1
	var flag = animationFlag
	await animation_player.animation_finished
	if flag == animationFlag:
		return true
	return false
	
func delay(duration: float) -> void:
	print("\n"+str(duration)+" delay start\n")
	await get_tree().create_timer(duration).timeout
	print("\n"+str(duration)+" delay end\n")
	
func _on_timer_timeout() -> void:
	vulnerable = true
	
	
