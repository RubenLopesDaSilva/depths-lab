class_name AttackArea extends Area2D

@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2;

var owner_player: Player;
var started: bool = false;
var lastDirection = 1;
var damage = 0;
var boddies = [];

func _ready() -> void:
	body_entered.connect(_on_body_entered);
	area_entered.connect(_on_body_entered);
	monitorable = false;
	monitoring = true;
	animated_sprite_2d_2.play("default");
	animated_sprite_2d_2.animation_finished.connect(queue_free);
	pass
	
func start(player: Player, dmg: int) -> void:
	started = true;
	owner_player = player;
	damage = dmg;
	global_position = owner_player.global_position + Vector2(owner_player.lastDirection * 40,-50);
	if owner_player.lastDirection == -1:
		lastDirection = 1;
		self.scale.x = self.scale.x * -1;
	
func _physics_process(delta: float) -> void:
	if started:
		global_position = owner_player.global_position + Vector2(owner_player.lastDirection * 40,-50);
		if owner_player.lastDirection != lastDirection:
			lastDirection = owner_player.lastDirection;
			self.scale.x = abs(self.scale.x) * lastDirection;
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") && not boddies.has(body):
		boddies.append(body);
		body.take_damage(damage);
