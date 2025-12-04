extends Area2D
@onready var timer: Timer = $Timer

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if(body.take_damage(20)):
		print("death")
		Engine.time_scale = 0.5
		timer.start()


func _on_timer_timeout() -> void:
	#Engine.time_scale = 1.0
	GameManager.restart()
	#get_tree().reload_current_scene();
