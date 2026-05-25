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
var lastPartState: PartState = PartState.INTRO;

var process_flag : int = 0;
var music_flag : int = 0;
var resetting : bool = false;

func _ready() -> void:
	music_player.stream = music_level_00;
	music_player.play();

func reset() -> void:
	resetting = true;
	music_player.stop();
	process_flag = 0;
	music_flag = 0;
	resetting = false;
	music_player.stream = music_level_00;
	music_player.play();

func change_state(value: MusicState, objection: bool = false) -> Variant:
	if not objection :
		if musicState == value:
			return;
	if musicState == MusicState.DEATH :
		return;
	musicState = value;
	partState = PartState.INTRO;
	lastPartState = PartState.NONE;
	music_flag += 1;
	process_flag = 0;
	handle_state();
	return music_flag;
	
func handle_state() -> void:	
	if resetting :
		return;
		
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
		elif partState == PartState.NONE:
			change_state(MusicState.LEVEL);
			return
		else:
			changed = false;
	if musicState == MusicState.CHASE:
		if partState == PartState.INTRO:
			music_player.stream = music_entity_chase_intro;
		elif partState == PartState.LOOP:
			music_player.stream = music_entity_chase_loop;
		elif partState == PartState.OUTRO:
			music_player.stream = music_entity_chase_outro;
		elif partState == PartState.NONE:
			change_state(MusicState.LEVEL);
			return
		else:
			changed = false;
	if musicState == MusicState.DEATH:
		if partState == PartState.INTRO:
			music_player.stream = music_death_intro;
		elif partState == PartState.LOOP:
			music_player.stream = music_death_loop
		elif partState == PartState.NONE:
			change_state(MusicState.LEVEL);
			return
		else:
			changed = false;
			
	match partState:
		PartState.INTRO:
			partState = PartState.LOOP;
			lastPartState = PartState.INTRO;
		PartState.LOOP:
			partState = PartState.OUTRO;
			lastPartState = PartState.LOOP;
		PartState.OUTRO:
			partState = PartState.NONE;
			lastPartState = PartState.OUTRO;
		
	if changed:
		music_player.play();
		var last_process = process_flag;
		var last_music = music_flag;
		await music_player.finished;
		if last_process == process_flag && last_music == music_flag:
			handle_state();
	else:
		handle_state();
		
func quite(flag: int) -> void:
	if flag == music_flag && (lastPartState == PartState.INTRO || lastPartState == PartState.LOOP):
		partState = PartState.OUTRO;
		process_flag += 1;
		music_player.stop();
		handle_state()
		
var boss = false;
var boss_id : int = -1;
var chase = false;
var chase_id : int = -1;

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F4:
			if boss:
				AudioManager.quite(boss_id);
				boss = false;
			else:
				var id = AudioManager.change_state(AudioManager.MusicState.BOSS);
				if id is int:
					boss_id = id;
				boss = true;
				
		elif event.keycode == KEY_F5:
			if chase:
				AudioManager.quite(chase_id);
				chase = false;
			else:
				var id = AudioManager.change_state(AudioManager.MusicState.CHASE);
				if id is int:
					chase_id = id;
				chase = true;
			
