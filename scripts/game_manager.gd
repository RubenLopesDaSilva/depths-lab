extends Node

signal map_ready;

var _map_is_ready : bool = false;

var _death_timer : Timer

func _ready() -> void:
	_death_timer = Timer.new()
	_death_timer.one_shot = true
	_death_timer.wait_time = 1
	_death_timer.timeout.connect(restart)
	add_child(_death_timer)
	
func restart() -> void:
	Engine.time_scale = 1;
	
func dying() -> void:
	AudioManager.change_state(AudioManager.MusicState.DEATH);
	Engine.time_scale = 0.5
	_death_timer.start()
	
func emit_map_ready() -> void:
	_map_is_ready = true;
	map_ready.emit();

func get_map_is_ready() -> bool :
	return _map_is_ready;
