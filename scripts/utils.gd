extends Node

func delay(duration: float) -> void:
	print("\n"+str(duration)+" delay start\n")
	await get_tree().create_timer(duration).timeout
	print("\n"+str(duration)+" delay end\n")
