extends CharacterBody2D

enum State { WALK, DAMAGE, DEATH }

var state = State.WALK;

const FORCE = 8;
const SPEED = 80;
var health = 3;

var lastDirection = 1;
var direction = 1;

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	update_direction()
	update_sprite()
	handle_actions()
	apply_movement(delta)

func update_direction() -> void:
	if ray_cast_right.is_colliding():
		direction = direction * -1;
	
func update_sprite() -> void:
	if direction > 0 && lastDirection < 0:
		lastDirection = 1
		self.scale.x = -self.scale.x
		
	if direction < 0 && lastDirection > 0:
		lastDirection = -1
		self.scale.x = -self.scale.x
	
func handle_actions() -> void:
	return
	
func apply_movement(delta: float) -> void:
	if not state == State.WALK:
		return
		
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, FORCE);
	else:
		velocity.x = move_toward(velocity.x, 0, FORCE);
		
	#if not is_on_floor():
		#velocity.y += get_gravity().y * delta
		
	move_and_slide()

func takeDamage():
	pass;

func death():
	pass;
