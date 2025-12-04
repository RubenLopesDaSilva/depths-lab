extends Node

func restart() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene();
	print('Restart')
