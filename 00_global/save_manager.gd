extends Node

const SAVE_PATH : String = "user://game.json";


var state : String = "";
var check_points : Array[String] = [];
var bosses : Array[String] = [];
var events : Array[String] = [];
var buttons : Array[String] = [];
var check_point : String = "";
var x : int = 0;
var y : int = 0;
var collectable : int = 0;
	

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
	state = "";
	check_points.clear();
	bosses.clear();
	events.clear();
	buttons.clear();
	check_point = "";
	x  = 0;
	y  = 0;
	collectable  = 0;
	save_game();

func to_json() -> Dictionary :
	return {
		"state" : state,
		"check_points" : check_points,
		"bosses" : bosses,
		"events": events,
		"buttons": buttons,
		"check_point": check_point,
		"x": x,
		"y": y,
		"collectable": collectable,
	};

func from_json(json : Dictionary) -> void :
	state = json["state"];
	check_points = json["check_points"];
	bosses = json["bosses"];
	events = json["events"];
	buttons = json["buttons"];
	check_point = json["check_point"];
	x  = int(json["x"]);
	y  = int(json["y"]);
	collectable  = int(json["collectable"]);

func set_state(value: String) -> void :
	state = value;

func activate_check_point(id: String) -> void :
	check_points.append(id);

func activate_boss(id: String) -> void :
	bosses.append(id);

func activate_event(id: String) -> void :
	events.append(id);

func activate_button(id: String) -> void :
	buttons.append(id);
