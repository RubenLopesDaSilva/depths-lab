extends Node

signal map_ready;
signal restart_game;

var _map_is_ready : bool = false;

var _death_timer : Timer

func _ready() -> void:
	pass
	_death_timer = Timer.new()
	_death_timer.one_shot = true
	_death_timer.wait_time = 2
	_death_timer.timeout.connect(_end_death)
	add_child(_death_timer)
	
func restart() -> void:
	Engine.time_scale = 1;
	AudioManager.reset();
	_map_is_ready = false;
	restart_game.emit();
	
func reset() -> void:
	SaveManager.reset();
	restart();
	
func dying() -> void:
	AudioManager.change_state(AudioManager.MusicState.DEATH);
	Engine.time_scale = 0.5
	_death_timer.start()
	
func _end_death() -> void :
	MenuCanva._show();
	
func emit_map_ready() -> void:
	_map_is_ready = true;
	map_ready.emit();
	AudioManager.change_state(AudioManager.MusicState.LEVEL);
	MenuCanva._show();

func get_map_is_ready() -> bool :
	return _map_is_ready;
