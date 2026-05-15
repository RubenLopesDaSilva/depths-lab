extends CharacterBody2D

enum State { WALK, DAMAGE, DEATH }

var state = State.WALK;

const FORCE = 8;
const SPEED = 80;
var health = 60;

var lastDirection = 1;
var direction = 1;

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

func take_damage(damage: int) -> void:
	if  state == State.WALK :
		health = health - damage;
	if health <= 0 :
		state = State.DEATH
		death();
	else: 
		state = State.DAMAGE
		animation_player.play("GetDamage")
		await animation_player.animation_finished
		state = State.WALK
		animation_player.play("Fly")

func death() -> void:
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free();
