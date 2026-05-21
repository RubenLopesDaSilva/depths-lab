extends Node

enum MusicState { LEVEL , BOSS, CHASE, DEATH }

enum PartState { NONE, INTRO, LOOP, OUTRO }

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

var musicState : MusicState = MusicState.LEVEL;
var partState: PartState = PartState.INTRO;

var flag : int = 0;

func _ready() -> void:
	music_player.stream = music_level_00;
	music_player.play();

func _process(delta: float) -> void:
	pass

func change_state(value: MusicState, objection: bool = false) -> void:
	if not objection :
		if musicState == value:
			return
	if musicState == MusicState.DEATH :
		return;
	musicState = value;
	partState = PartState.INTRO;
	handle_state();
	
func handle_state() -> void:	
	var changed : bool = true;
	if musicState == MusicState.LEVEL:
		music_player.stream = music_level_00;
	if musicState == MusicState.BOSS:
		if partState == PartState.INTRO:
			music_player.stream = music_bossy_intro;
		elif partState == PartState.LOOP:
			music_player.stream = music_bossy_loop;
		elif partState == PartState.OUTRO:
			music_player.stream = music_bossy_outro
		else:
			changed = false;
			change_state(MusicState.LEVEL);
	if musicState == MusicState.CHASE:
		if partState == PartState.INTRO:
			music_player.stream = music_entity_chase_intro;
		elif partState == PartState.LOOP:
			music_player.stream = music_entity_chase_loop;
		elif partState == PartState.OUTRO:
			music_player.stream = music_entity_chase_outro;
		else:
			changed = false;
			change_state(MusicState.LEVEL);
	if musicState == MusicState.DEATH:
		if partState == PartState.INTRO:
			music_player.stream = music_death_intro;
		elif partState == PartState.LOOP:
			music_player.stream = music_death_loop
		else:
			changed = false;
			change_state(MusicState.LEVEL);
			
	match partState:
		PartState.INTRO:
			partState = PartState.LOOP;
		PartState.LOOP:
			partState = PartState.OUTRO;
		PartState.OUTRO:
			partState = PartState.NONE;
		
	if changed:
		flag += 1;
		music_player.play();
		var last_flage = flag;
		await music_player.finished;
		if last_flage == flag:
			handle_state();
	else:
		handle_state();
		
func quite(value: MusicState) -> void:
	if musicState == value:
		partState = PartState.OUTRO;
		flag += 1;
		music_player.stop();
		handle_state()
