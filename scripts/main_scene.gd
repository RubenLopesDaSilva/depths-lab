extends Node

@export var map_00 : PackedScene;
@export var map_01 : PackedScene;
@export var map_02 : PackedScene;
@export var map_03 : PackedScene;
@export var boss_00 : PackedScene;

var scene : Node;

func _ready() -> void:
	if not GameManager.restart_game.is_connected(restart) :
		GameManager.restart_game.connect(restart);
	if not SceneManager.transition_requested.is_connected(change_scene):
		SceneManager.transition_requested.connect(change_scene);
	
	start();
	
func start () -> void :
	SaveManager.load_game();
	
	if scene:
		scene.queue_free();
		await scene.tree_exited;
	
	var packed_scene = null;
	if SaveManager.state == SaveManager.GameState.BEGIN :
		packed_scene = map_00;
	elif SaveManager.state == SaveManager.GameState.NORMAL :
		var check_point_id = SaveManager.check_point;
		if check_point_id == "CP00":
			packed_scene = map_00;
		elif check_point_id == "CP01":
			packed_scene = map_03;
		else :
			return
	
	scene = packed_scene.instantiate();
	add_child(scene);
	call_deferred("emit_map_ready");

func restart() -> void :
	var player = get_tree().get_first_node_in_group("Player");
	if player :
		player.queue_free();
	start();

func change_scene(value: String, target: String, offset: Vector2, dir: String) -> void :
	if scene:
		scene.queue_free();
		await scene.tree_exited;
	
	var packed_scene = null;
	
	if value == "Map00":
		packed_scene = map_00;
	elif value == "Map01":
		packed_scene = map_01;
	elif value == "Map02":
		packed_scene = map_02;
	elif value == "Map03" :
		packed_scene = map_03;
	elif value == "Boss00" :
		packed_scene = boss_00;
	else :
		return;
	
	scene = packed_scene.instantiate();
	
	add_child(scene);
	
	#emit_map_ready();
	
	SceneManager.finish_transition(target, offset, dir);

func emit_map_ready() -> void : 
	GameManager.emit_map_ready();
