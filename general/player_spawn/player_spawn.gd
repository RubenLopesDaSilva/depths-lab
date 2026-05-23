class_name PlayerSpawn extends Node2D

@export var packed_player : PackedScene;

var player : Player;

func _ready() -> void:
	visible = false;
	
	if not GameManager.map_ready.is_connected(_on_map_ready):
		GameManager.map_ready.connect(_on_map_ready);

func _on_map_ready() -> void :
	
	if SaveManager.state == SaveManager.GameState.BEGIN :
		_spawn_player();

func _spawn_player() -> void:
	if get_tree().get_first_node_in_group("Player"):
		print("We have a player")
		return;
	
	print("No player found");
	
	player = packed_player.instantiate();
	player.scale = Vector2(2,2);
	get_tree().root.add_child(player)
	player.global_position = self.global_position;
