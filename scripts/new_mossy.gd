extends CharacterBody2D

var state = State.WALK;

const FORCE = 6;
const SPEED = 60;

var health = 5;
var live = 100;

var lastDirection = 1;
var direction = 1;

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_bottom: RayCast2D = $RayCastBottom
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum State { WALK, DAMAGE, DEATH }

func _physics_process(delta: float) -> void:
	update_direction()
	update_sprite()
	handle_actions()
	apply_movement(delta)

func update_direction() -> void:
	if ray_cast_right.is_colliding() || (is_on_floor() &&  not ray_cast_bottom.is_colliding()):
		direction = direction * -1;
	#if ray_cast_left.is_colliding():
		#direction = 1;
	
func update_sprite() -> void:
	if direction > 0 && lastDirection < 0:
		lastDirection = 1
		self.scale.x = -self.scale.x
		
	if direction < 0 && lastDirection > 0:
		lastDirection = -1
		self.scale.x = -self.scale.x
	
func handle_actions() -> void:
	#if state == State.DEATH:
		#return
	return
	
func apply_movement(delta: float) -> void:
	if not state == State.WALK:
		return
	#if state == State.DEATH:
		#velocity.x = move_toward(velocity.x, 0, SPEED / 30)
	#else:
		#if (is_on_floor()):
			#if direction == 0:
				#set_state(State.IDLE)
			#else:
				#set_state(State.WALK)
		
	if direction:
		#velocity.x = direction * SPEED;
		velocity.x = move_toward(velocity.x, SPEED * direction, FORCE);
	else:
		velocity.x = move_toward(velocity.x, 0, FORCE);
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	move_and_slide()

func take_damage(damage: int) -> void:
	if  state == State.WALK :
		live = live - damage;
		if live <= 0 :
			state = State.DEATH
			death();
		else: 
			state = State.DAMAGE
			animation_player.play("GetDamage")
			await animation_player.animation_finished
			state = State.WALK
			animation_player.play("Walk")
		

func death() -> void:
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free();
