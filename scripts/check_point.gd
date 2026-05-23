extends Area2D

@export var id: String;

@export var packed_player : PackedScene;
@export var animated_sprite: AnimatedSprite2D;
@export var control: Control;
@export var label: Label;

var is_inside: bool = false;
var available: bool = false;
var active: bool = false;

var save_text: String = "Appuyer W pour sauvegarder";
var saved_text: String = "Sauvegarde effectuée";

var player : Player = null;

func _ready() -> void:
	label.text = save_text;
	if GameManager.get_map_is_ready() :
		
		active = SaveManager.is_active_check_point(id);
		if active:
			animated_sprite.play("active");
			
	if not GameManager.map_ready.is_connected(_on_map_ready):
		GameManager.map_ready.connect(_on_map_ready);
	
func _on_map_ready() -> void : 
		active = SaveManager.is_active_check_point(id);
		if active:
			animated_sprite.play("active");
			
		if SaveManager.state == SaveManager.GameState.NORMAL && SaveManager.check_point == id:
			_spawn_player();

	
func _spawn_player() -> void:
	if get_tree().get_first_node_in_group("Player"):
		return;
	
	player = packed_player.instantiate();

	player.set_player(SaveManager.collectable, SaveManager.direction, Vector2(2,2));
	
	get_tree().root.add_child(player)
	
	player.global_position = SaveManager.position;

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		label.text = save_text;
		available = true;
		is_inside = true;
		if player == null :
			player = body;

func _on_body_exited(body: Node2D) -> void:
	if body == player :
		is_inside = false;

func _process(delta: float) -> void:
	if is_inside :
		control.show();
		if Input.is_action_just_pressed("up") && available:
			save();
	else :
		control.hide(); 
	
func save() -> void:
	available = false;
	label.text = saved_text;
	player.set_health(5);
	if not active:
		active = true;
		_activate();
		
	SaveManager.set_state(SaveManager.GameState.NORMAL);
	SaveManager.set_check_point(id);
	SaveManager.set_collectable(player.collectables);
	SaveManager.set_position(player.global_position);
	SaveManager.set_direction(player.lastDirection);
	
	SaveManager.save_game();

func _activate() -> void:
	SaveManager.activate_check_point(id);
	animated_sprite.play("active");
