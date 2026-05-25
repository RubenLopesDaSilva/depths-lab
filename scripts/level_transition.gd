@tool
class_name LevelTransition
extends Node2D

enum SIDE { RIGHT, LEFT, TOP, BOTTOM}

@export_range(1,12,1,'or_greater') var size : int = 2 :
	set( value ):
		size = value
		apply_area_settings();

@export var location : SIDE = SIDE.LEFT :
	set(value):
		location = value
		apply_area_settings();

@export var target : String = ""
@export var target_area_name : String = "LevelTransition"

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	apply_area_settings()

	if not area_2d.body_entered.is_connected(_on_player_entered):
		area_2d.body_entered.connect(_on_player_entered)

	area_2d.monitoring = true

	SceneManager.new_scene_ready.connect(_on_new_scene_ready)
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)

func _on_player_entered(_n: Node2D) -> void:
	SceneManager.transition_scene(target,target_area_name,get_offset(_n),get_transition_direction())
	pass

func _on_new_scene_ready(target_name:String, offset: Vector2) -> void:
	if !is_inside_tree():
		return

	if target_name == name:
		var player = get_tree().get_first_node_in_group("Player")

		if player:
			player.global_position = global_position + offset

func _on_load_scene_finished() -> void:
	area_2d.monitoring = true


func apply_area_settings() -> void:
	area_2d = get_node_or_null("Area2D")
	if not area_2d:
		return;
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		area_2d.scale.y = size;
		if location == SIDE.LEFT:
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
	pass
func get_offset(player: Node2D) -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var _player_pos : Vector2 = player.global_position
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		
		if location == SIDE.LEFT:
			offset.x = -80 
		else:
			offset.x = 120
	else:
		if location == SIDE.TOP:
			offset.y = -3
		else:
			offset.x = 33
	return offset;

func get_transition_direction() -> String:
	match location:
		SIDE.LEFT:
			return "left";
		SIDE.RIGHT:
			return "right";
		SIDE.TOP:
			return "up";
		_:
			return "down";
