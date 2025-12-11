extends Node

var death_timer : Timer

func _ready() -> void:
	death_timer = Timer.new()
	death_timer.one_shot = true
	death_timer.wait_time = 1
	death_timer.timeout.connect(restart)
	add_child(death_timer)
	
func restart() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene();
	print('Restart')
	
func dying() -> void:
	print("Death")
	Engine.time_scale = 0.5
	death_timer.start()
