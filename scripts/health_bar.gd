extends CanvasLayer

@export var animation_player: AnimationPlayer;

var life: int = 100;

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
 
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
