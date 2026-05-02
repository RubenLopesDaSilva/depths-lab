extends CharacterBody2D

const FORCE = 6;
const SPEED = 60;
var health = 5;

var lastDirection = 1;
var direction = 1;

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

func _physics_process(delta: float) -> void:
	update_direction()
	update_sprite()
	handle_actions()
	apply_movement(delta)

func update_direction() -> void:
	if ray_cast_right.is_colliding():
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

func takeDamage():
	pass;

func death():
	pass;
