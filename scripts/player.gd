extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var next_animation = "idle"
var is_dead = false;
var i_frames = false;
var health = 100;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


func _physics_process(delta: float) -> void:
	if(is_dead):
		return;
		
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if (Input.is_action_just_pressed("Attack")):
		next_animation = "Attack"
		Attack()
		await animated_sprite.animation_finished
		next_animation = "Idle"
		
	if animated_sprite.animation == "GetDamage":
		direction = 0
		await animated_sprite.animation_finished
		next_animation = "Idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		next_animation = "Jump"
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if direction > 0:
		animated_sprite.flip_h = false
		
	if direction < 0:
		animated_sprite.flip_h = true
		
	if (is_on_floor() and next_animation != "Attack"):
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Walk")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func Death() -> void:
	is_dead = true;
	animated_sprite.play("Death");

func take_damage() -> void:
	if not i_frames:
		next_animation = "GetDamage"
		animated_sprite.play("GetDamage")
		health -= 20;
		i_frames = true
		timer.start()

func Attack()-> void:
	animated_sprite.play("FirstAttack")

func _on_timer_timeout() -> void:
	i_frames = false;
