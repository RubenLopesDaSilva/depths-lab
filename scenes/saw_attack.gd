extends Node2D

const SPEED = 300.0
var direction: Vector2 = Vector2.LEFT
@onready var animation_tree: AnimationTree = $AnimationTree

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1);

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	
	if direction.x > 0:
		animation_tree.set("parameters/conditions/is_left",false)
		animation_tree.set("parameters/conditions/is_right",true)
	else:
		animation_tree.set("parameters/conditions/is_right",false)
		animation_tree.set("parameters/conditions/is_left",true)
		
		
func _process(delta: float) -> void:
	position += direction * SPEED * delta;

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
