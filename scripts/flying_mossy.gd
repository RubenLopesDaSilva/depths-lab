extends CharacterBody2D;

enum State { NONE, FLY, DAMAGE, DEATH };

var state = State.NONE;

const FORCE = 8;
const SPEED = 80;
var health = 60;

var lastDirection = 1;
var direction = 1;

@onready var ray_cast_right: RayCast2D = $RayCastRight;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@export var sound_player : AudioStreamPlayer2D;

func _ready() -> void:
	set_state(State.FLY);

func _process(delta):
	update_direction();
	update_sprite();
	handle_actions();
	apply_movement(delta);

func update_direction() -> void:
	if ray_cast_right.is_colliding():
		direction = direction * -1;
	
func update_sprite() -> void:
	if direction > 0 && lastDirection < 0:
		lastDirection = 1;
		self.scale.x = -self.scale.x;
		
	if direction < 0 && lastDirection > 0:
		lastDirection = -1;
		self.scale.x = -self.scale.x;
	
func handle_actions() -> void:
	return;
	
func apply_movement(_delta: float) -> void:
	if not state == State.FLY:
		return;
		
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, FORCE);
	else:
		velocity.x = move_toward(velocity.x, 0, FORCE);
		
	move_and_slide();
	
func set_state(value: State) :
	if value == state :
		return;
	if value == State.FLY:
		sound_player.play();
	else :
		sound_player.stop();
	
	state = value;

func take_damage(damage: int) -> void:
	if state == State.DEATH:
		return;
	if  state == State.FLY :
		health = health - damage;
	if health <= 0 :
		death();
	else: 
		set_state(State.DAMAGE);
		animation_player.play("GetDamage");
		await animation_player.animation_finished;
		set_state(State.FLY);
		animation_player.play("Fly");

func death() -> void:
	set_state(State.DEATH);
	animation_player.play("Death");
	await animation_player.animation_finished;
	queue_free();;
