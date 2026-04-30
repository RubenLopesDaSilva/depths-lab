extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0

var direction = 1;

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if ray_cast_right.is_colliding():
		direction = -1;
		animated_sprite_2d.flip_h = true;
	
	if ray_cast_left.is_colliding():
		direction = 1;
		animated_sprite_2d.flip_h = false;
	
	velocity.x = SPEED * delta * direction;

	move_and_slide();
