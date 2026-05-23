extends Node

@export var map_00 : PackedScene;
@export var map_01 : PackedScene;
@export var map_02 : PackedScene;

var scene : Node;

func _ready() -> void:
	SaveManager.load_game();
	
	var packed_scene = null;
	if SaveManager.state == SaveManager.GameState.BEGIN :
		packed_scene = map_00;
	elif SaveManager.state == SaveManager.GameState.NORMAL :
		var check_point_id = SaveManager.check_point;
		if check_point_id == "CP00":
			packed_scene = map_00;
	
	scene = packed_scene.instantiate();
	add_child(scene);
	call_deferred("emit_map_ready");
	
func emit_map_ready() -> void : 
	GameManager.emit_map_ready();
