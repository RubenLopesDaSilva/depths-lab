# Save manager script
extends Node

var current_slot : int = 0;
var save_data : Dictionary;
var discovered_areas : Array = [];
var persistent_data : Dictionary = {};



func _ready() -> void:
	pass
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F7:
			create_new_game_save();
		elif event.keycode == KEY_F6:
			load_game();
		elif  event.keycode == KEY_F2:
			save_game();
	pass

func save_game() -> void:
	print("save game");
	pass

func load_game() -> void:
	print("load game");
	pass

func create_new_game_save() -> void:
	var new_game_scene : String ="uid://cdtwgxyy3f0f4";
	discovered_areas.append(new_game_scene);
	save_data = {
		"scene_path": new_game_scene,
		"x": -205,
		"y": -1,
		"hp": 200,
		"max_hp": 200,
		"dash": false,
		"double_jump": false,
		"discovered_areas": discovered_areas,
		"persistent_data": persistent_data
	}
	var save_file = FileAccess.open("user://save.sav",FileAccess.WRITE);
	save_file.store_line( JSON.stringify(save_data));
	pass
