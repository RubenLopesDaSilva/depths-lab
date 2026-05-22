extends CanvasLayer

@export var animation_player: AnimationPlayer;
@export var collectable_label: Label;

var life: int = 100;
 
func set_health(percentage: float) -> void: 
	if percentage > 80:
		animation_player.play("full");
	elif percentage > 60:
		animation_player.play("great");
	elif percentage > 40:
		animation_player.play("half");
	elif percentage > 20:
		animation_player.play("depleted");
	elif percentage > 0:
		animation_player.play("critical");
	else:
		animation_player.play("empty");

func set_collectable(value: int) -> void:
	collectable_label.text = str(value);
