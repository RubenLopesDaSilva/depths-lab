extends Area2D
var bodys : Array[Node2D] = []
@onready var timer: Timer = $Timer


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.take_damage();
	print(body.health)
	if(body.health == 0):
		await body.Death();
		Engine.time_scale = 0.5
		timer.start();


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_method("takeDamage") && not bodys.has(body):
		if bodys.is_empty():
			timer.start()
		bodys.append(body)

func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	bodys.erase(body)
	if bodys.is_empty():
		timer.stop()
 
func _on_timer_timeout() -> void:
	for body in bodys:
		body.takeDamage(20)
