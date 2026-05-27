extends Area2D
class_name Trigger

const boss_scene = preload("res://scenes/experiment_215_s.tscn")
const musicState = AudioManager.MusicState;
var already_started : bool
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var boss_timer: Timer = $"../BossTimer"
@export var packed_player : PackedScene


var player : Player = null
var active : bool = false
var temps_ecoule: float = 0.0
const id : String = 'boss00'

func _ready() -> void:
	if  GameManager.get_map_is_ready():
		active = SaveManager.is_active_boss(id)
		_on_map_ready()
		
	if not GameManager.map_ready.is_connected(_on_map_ready):
		GameManager.map_ready.connect(_on_map_ready);
		_on_map_ready()
	_on_map_ready()
	already_started = false

func _on_map_ready() -> void:
	active = SaveManager.is_active_boss(id)
	if SaveManager.state == SaveManager.GameState.BOSS && SaveManager.check_point == id:
		_spawn_player()

func _spawn_player() -> void:
	if get_tree().get_first_node_in_group("Player"):
		return
	player = packed_player.instantiate()
	player.set_player(SaveManager.collectable,SaveManager.direction,Vector2(2,2))
	
	get_tree().current_scene.get_parent().add_child(player)
	
	player.global_position = SaveManager.position

func save()->void:
	player.set_health(5)
	if not active:
		active = true
		SaveManager.activate_boss(id)
	
	SaveManager.set_state(SaveManager.GameState.BOSS);
	SaveManager.set_check_point(id);
	SaveManager.set_collectable(player.collectables);
	SaveManager.set_position(player.global_position);
	SaveManager.set_direction(player.lastDirection);
	SaveManager.save_game();


func _process(delta: float) -> void:
	if temps_ecoule < 1.0:
		temps_ecoule += delta

func _on_body_entered(body: Node2D) -> void:
	_on_map_ready()
	if temps_ecoule < 1.0:
		return
	if already_started:
		return
	
	if body.is_in_group("Player"):
		camera_2d.enabled = true
		camera_2d.make_current()
		already_started = true
		boss_timer.start(2.5)
		AudioManager.change_state(musicState.BOSS)
		


func _on_boss_timer_timeout() -> void:
	var boss = boss_scene.instantiate()
	boss.set_trigger(self)
	boss.position = Vector2(865.0,2)
	boss.scale = Vector2(5,5)
	get_tree().current_scene.call_deferred("add_child",boss)
	
