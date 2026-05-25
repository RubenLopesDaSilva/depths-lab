extends Area2D

enum Type { GREEN, BLUE, YELLOW, PURPLE }

@export var type : Type = Type.GREEN;
@export var sprite : AnimatedSprite2D;
@export var sound_player : AudioStreamPlayer;

var value : int  = 0;

func _ready() -> void:
		if type == Type.GREEN:
			value = 1;
			sprite.play("green");
		elif type == Type.BLUE:
			value = 5;
			sprite.play("blue");
		elif type == Type.YELLOW:
			value = 20;
			sprite.play("yellow");
		elif type == Type.PURPLE:
			value = 50;
			sprite.scale *= 2;
			sprite.play("purple");

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect_collectables(value);
		sound_player.play()
		sprite.hide();
		await sound_player.finished;
		queue_free();
		
