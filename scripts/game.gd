extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Engine ready")
	Engine.time_scale = 1.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restart() -> void:
	get_tree().reload_current_scene();
