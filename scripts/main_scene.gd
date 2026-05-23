extends Node

func _ready() -> void:
	SaveManager.load_game();
	
	await get_tree().process_frame;
	
	get_tree().change_scene_to_file("res://scenes/00.tscn");
