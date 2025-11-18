extends Area2D
@onready var timer: Timer = $Timer

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	body.take_damage();
	if(body.health == 0):
		body.Death();
		Engine.time_scale = 0.2
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene();
