extends Node

enum State { LEVEL , BOSS, CHASE, DEATH }

@onready var music_player: AudioStreamPlayer = $MusicPlayer

@export var music_level_00 : AudioStream;

@export var music_bossy_intro : AudioStream;
@export var music_bossy_loop : AudioStream;
@export var music_bossy_outro : AudioStream;

@export var music_death_intro : AudioStream;
@export var music_death_loop : AudioStream;

@export var music_entity_chase_intro : AudioStream;
@export var music_entity_chase_loop : AudioStream;
@export var music_entity_chase_outro : AudioStream;

var state : State = State.LEVEL;
var flag : int = 0;

func _ready() -> void:
	music_player.stream = music_level_00;
	music_player.play();

func _process(delta: float) -> void:
	pass

func change_state(value: State, objection: bool = false) -> void:
	if(not objection):
		if state == value:
			return
	state = value;
	flag = 0;
	handle_state();
	
func handle_state() -> void:	
	if state == State.LEVEL:
		music_player.stream = music_level_00;
	if state == State.BOSS:
		if flag == 0:
			music_player.stream = music_bossy_intro;
		elif flag == 1:
			music_player.stream = music_bossy_loop;
		elif flag == 2:
			music_player.stream = music_bossy_outro
		else:
			change_state(State.LEVEL);
	if state == State.CHASE:
		if flag == 0:
			music_player.stream = music_entity_chase_intro;
		elif flag == 1:
			music_player.stream = music_entity_chase_loop;
		elif flag == 2:
			music_player.stream = music_entity_chase_outro;
		else:
			change_state(State.LEVEL);
	if state == State.DEATH:
		if flag == 0:
			music_player.stream = music_death_intro;
		elif flag == 1 :
			music_player.stream = music_death_loop
		else:
			change_state(State.LEVEL);
	music_player.play();
	flag += 1;
	await music_player.finished;
	finish(state)
	
func finish(state: State) -> void:
	pass
