class_name PlayerSpawn extends Node2D


func _ready() -> void:
	visible = false;
	await get_tree().process_frame;
	
	if get_tree().get_first_node_in_group("Player"):
		print("We have a player")
		return;

	print("No player found");
	
	var player : Player = load("uid://bew4d6ojw3kyv").instantiate();
	player.scale = Vector2(2,2);
	get_tree().root.add_child(player)
	player.global_position = self.global_position;
	
	pass;
