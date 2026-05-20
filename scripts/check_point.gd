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

func _ready() -> void:
	label.text = save_text;
	if active:
		animated_sprite.play("active");
	
	
func _on_body_entered(body: Node2D) -> void:
	label.text = save_text;
	available = true;
	is_inside = true;

func _on_body_exited(body: Node2D) -> void:
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
	if not active:
		active = true;
		_activate();
	print("save");

func _activate() -> void:
	print("activate");
	animated_sprite.play("active");
