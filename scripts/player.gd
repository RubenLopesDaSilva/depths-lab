class_name Player extends CharacterBody2D

enum State { IDLE, WALK, JUMP, FALL, LAND, ATTACK, DAMAGE, DEATH }

enum AttackState { NONE, FIRST, SECOND, DISABLE }

const FORCE: float = 20.0
const SPEED: float = 200.0
const JUMP_VELOCITY: float = -550.0

var state: State = State.IDLE
var attack_state: AttackState = AttackState.NONE
var health: float = 5
var notOnFloor: bool = false
var direction: int = 0
var lastDirection: int = 1;
var vulnerable: bool = true
var animationFlag: int = 0
var close: bool = false
var running: bool = false;
var multiplicator: float = 1;
var collectables : int = 0;

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vulnerableTimer: Timer = $Iframes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var run_dusk_sprite: AnimatedSprite2D = $RunDuskSprite

@export var attack_area: PackedScene;
@export var second_attack_area: PackedScene;

func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self :
		self.queue_free()
	self.call_deferred("reparent",get_tree().root)
	run_dusk_sprite.hide();

func _physics_process(delta: float) -> void:
	update_direction()
	update_sprite()
	handle_actions()
	apply_movement(delta)
	
func update_direction() -> void:
	if state != State.DAMAGE && state != State.DEATH:
		direction = Input.get_axis("move_left", "move_right")
	
func update_sprite() -> void:
	if direction > 0 && lastDirection < 0:
		lastDirection = 1
		self.scale.x = -self.scale.x
		
	if direction < 0 && lastDirection > 0:
		lastDirection = -1
		self.scale.x = -self.scale.x
	
func handle_actions() -> void:
	if state == State.DEATH:
		return
	if (Input.is_action_just_pressed("attack")):
		attack()	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_state(State.JUMP);
		velocity.y = JUMP_VELOCITY
	if state == State.WALK && Input.is_action_pressed("shift") && not running:
		running = true;
		run_dusk_sprite.show();
		play_animation();
	elif (not Input.is_action_pressed("shift") || not state == State.WALK) && running:
		running = false;
		run_dusk_sprite.hide();
		play_animation();
	if not is_on_floor() && velocity.y > 0:
		notOnFloor = true
		set_state(State.FALL)
	elif notOnFloor:
		notOnFloor = false
		set_state(State.LAND)
	
func apply_movement(delta: float) -> void:
	if state == State.DEATH:
		velocity.x = move_toward(velocity.x, 0, SPEED / 30.0)
	else:
		if (is_on_floor()):
			if direction == 0:
				set_state(State.IDLE)
			else:
				set_state(State.WALK)
		
		if direction:
			if running :
				multiplicator = 2;
			else : 
				multiplicator = move_toward(multiplicator, 1, 0.005);
			velocity.x = move_toward(velocity.x, multiplicator * SPEED * direction, FORCE);
		else:
			velocity.x = move_toward(velocity.x, 0, FORCE);
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	move_and_slide()
	
func set_state(value: State, objection: bool = false, play: bool = true) -> void:
	if(not objection):
		if state == value:
			return
		if state == State.FALL && (value == State.IDLE || value == State.WALK) :
			return
		if state == State.LAND && (value == State.IDLE || value == State.WALK || value == State.FALL) :
			return
		if  state == State.DAMAGE && value != State.DEATH :
			return
		if  state == State.JUMP && (value != State.DEATH && value != State.DAMAGE && value != State.FALL && value != State.LAND && value != State.ATTACK) :
			return
		if state == State.ATTACK && (value != State.DEATH && value != State.DAMAGE) :
			return
	if state == State.DEATH : 
		return
	state = value
	if	play:
		play_animation()
	
func set_attack_state(value: AttackState) -> void:
	if state != State.ATTACK:
		return
	if value == attack_state:
		return
	attack_state = value;
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
	if running:
		animation_player.play("Run");
	else :
		animation_player.play("Walk");
	
func play_jump() -> void:
	animation_player.play("Jump")
	
func play_fall() -> void:
	animation_player.play("Fall")
	
func play_land() -> void:
	animation_player.play("Land")
	if await animation_finished_correctly():
		set_state(State.IDLE, true)
	
func play_attack() -> void:
	if attack_state == AttackState.FIRST:
		await Utils.delay(0.2)
		close = true
		if attack_state == AttackState.FIRST:
			animation_player.play("FirstAttack")
			var attackArea = attack_area.instantiate();
			attackArea.start(self, 20);
			get_parent().add_child(attackArea);
	elif attack_state == AttackState.SECOND:
		animation_player.play("SecondAttack")
		var secondAttackArea = second_attack_area.instantiate();
		secondAttackArea.start(self, 20);
		await Utils.delay(0.5);
		get_parent().add_child(secondAttackArea);
	if	await animation_finished_correctly(): 
		set_state(State.IDLE, true)
	close = false
	attack_state = AttackState.DISABLE
	await Utils.delay(0.2)
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
		StatesBar.set_health(health/5.0*100);
		if (health <= 0):
			death()
		else:
			set_state(State.DAMAGE)
			vulnerable = false
			vulnerableTimer.start()
	
func death() -> void:
	set_state(State.DEATH)
	
func animation_finished_correctly() -> bool:
	animationFlag += 1
	var flag = animationFlag
	await animation_player.animation_finished
	if flag == animationFlag:
		return true
	return false
	
func get_collectable(value: int) -> void:
	collectables += value;
	StatesBar.set_collectable(collectables);
	
func _on_timer_timeout() -> void:
	vulnerable = true
	
