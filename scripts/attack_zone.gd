extends Area2D


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.takeDamage();
	if(body.health == 0):
		await body.Death();
		
