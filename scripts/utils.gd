extends Node

func delay(duration: float) -> void:
	await get_tree().create_timer(duration).timeout
