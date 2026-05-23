extends Node

enum GameState { NONE, BEGIN, NORMAL };

const SAVE_PATH : String = "user://game.json";

var state : GameState = GameState.NONE;
var check_point : String = "";
var position : Vector2 = Vector2(0,0);
var direction: int = 1;
var collectable : int = 0;
var check_points : Array[String] = [];
var bosses : Array[String] = [];
var events : Array[String] = [];
var buttons : Array[String] = [];
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F7:
			reset();
		elif event.keycode == KEY_F6:
			load_game();
		elif  event.keycode == KEY_F2:
			save_game();

func load_game() -> void:
	print("load game");
	
	if not FileAccess.file_exists(SAVE_PATH) :
		print("Pas de sauvegarde")
		reset();
		return;
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ);
		
	if file == null :
		print("Erreur de lecture : Load");
		return;
		
	var content = file.get_as_text();
	file.close();
	
	var data = JSON.parse_string(content);
	
	if data == null or not data is Dictionary :
		print("Invalide Json");
		return;
	
	from_json(data);

func save_game() -> void:
	print("save game");
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE);
	
	if file == null :
		print("Erreur de lecture : Save");
		return;
		
	file.store_string(JSON.stringify(to_json()));
	file.close();
	
func reset () -> void :
	state = GameState.BEGIN;
	check_point = "";
	position = Vector2(0,0);
	collectable = 0;
	direction = 0;
	check_points.clear();
	bosses.clear();
	events.clear();
	buttons.clear();
	save_game();

func to_json() -> Dictionary :
	return {
		"state" : from_state(),
		"check_point": check_point,
		"x": position.x,
		"y": position.y,
		"direction": direction,
		"collectable": collectable,
		"check_points" : check_points,
		"bosses" : bosses,
		"events": events,
		"buttons": buttons,
	};

func from_json(json : Dictionary) -> void :
	print(json)
	to_state(json["state"]);
	check_point = json["check_point"];
	position = Vector2(float(json["x"]), float(json["y"]));
	direction = int(json["direction"]);
	collectable  = int(json["collectable"]);
	
	check_points.clear();
	for value in json["check_points"] :
		check_points.append(value);
	
	bosses.clear();
	for value in  json["bosses"] :
		bosses.append(value);
		
	events.clear();
	for value in json["events"] :
		events.append(value);
		
	buttons.clear();
	for value in json["buttons"] :
		buttons.append(value);
		
	if state == GameState.NONE :
		reset();
		load_game();

func to_state(value: String) -> void :
	match value:
		"":
			state = GameState.BEGIN;
		"normal":
			state = GameState.NORMAL;
		"none", _:
			state = GameState.NONE;
			

func from_state() -> String :
	match state:
		GameState.BEGIN :
			return "";
		GameState.NORMAL:
			return "normal";
		GameState.NONE, _:
			return "none"

func set_state(value: GameState) -> void :
	state = value;

func set_check_point(id: String) -> void :
	check_point = id;
	
func set_position(value: Vector2) -> void :
	position = value;

func set_direction(value: int) -> void :
	direction = value;

func set_collectable(value: int) -> void :
	collectable = value;

func activate_check_point(id: String) -> void :
	check_points.append(id);

func activate_boss(id: String) -> void :
	bosses.append(id);

func activate_event(id: String) -> void :
	events.append(id);

func activate_button(id: String) -> void :
	buttons.append(id);
	
func is_active_check_point(id: String):
	return check_points.has(id);
