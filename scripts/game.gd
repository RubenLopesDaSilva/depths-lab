extends Node2D

func _ready() -> void:
	print("Engine ready")
	Engine.time_scale = 1.0

func _process(delta: float) -> void:
	pass

func restart() -> void:
	get_tree().reload_current_scene();
