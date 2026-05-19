extends Area2D

@export var id: String;

@export var animated_sprite: AnimatedSprite2D;

@export var control: Control;
@export var label: Label;
@export var progressBar: ProgressBar;

var is_inside: bool = false;

func _on_body_entered(body: Node2D) -> void:
	is_inside = true;
	print("enter");

func _on_body_exited(body: Node2D) -> void:
	is_inside = false;

func _process(delta: float) -> void:
	if is_inside :
		control.show();
	else :
		control.hide(); 
		
