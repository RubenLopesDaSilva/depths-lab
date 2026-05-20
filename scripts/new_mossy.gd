extends CharacterBody2D

var state = State.WALK;

const FORCE = 6;
const SPEED = 60;

var health = 100;

var lastDirection = 1;
var direction = 1;

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
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	move_and_slide()

func take_damage(damage: int) -> void:
	if state == State.DEATH:
		return
	if  state == State.WALK :
		health = health - damage;
		if health <= 0 :
			death();
		else: 
			state = State.DAMAGE
			animation_player.play("GetDamage")
			await animation_player.animation_finished
			state = State.WALK
			animation_player.play("Walk")
		

func death() -> void:
	state = State.DEATH
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free();
