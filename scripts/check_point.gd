extends Area2D

@export var id: String;

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
	active = SaveManager.is_active_check_point(id);
	if active:
		animated_sprite.play("active");
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		label.text = save_text;
		available = true;
		is_inside = true;
		player = body;

func _on_body_exited(body: Node2D) -> void:
	if body is Player :
		is_inside = false;
		player = null;

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
	if not active:
		active = true;
		_activate();
		
	SaveManager.set_state(SaveManager.GameState.NORMAL);
	SaveManager.set_check_point(id);
	SaveManager.set_collectable(player.collectables);
	SaveManager.set_position(player.position);
	
	SaveManager.save_game();

func _activate() -> void:
	SaveManager.activate_check_point(id);
	animated_sprite.play("active");
