extends Node

signal map_ready;

var death_timer : Timer

func _ready() -> void:
	death_timer = Timer.new()
	death_timer.one_shot = true
	death_timer.wait_time = 1
	death_timer.timeout.connect(restart)
	add_child(death_timer)
	
func restart() -> void:
	Engine.time_scale = 1;
	
func dying() -> void:
	AudioManager.change_state(AudioManager.MusicState.DEATH);
	Engine.time_scale = 0.5
	death_timer.start()
	
func emit_map_ready() -> void:
	map_ready.emit();
