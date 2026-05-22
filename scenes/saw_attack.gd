extends Node2D

const SPEED = 300.0
var direction: Vector2 = Vector2.LEFT

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1);
		
func _process(delta: float) -> void:
	position += direction * SPEED * delta;

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
