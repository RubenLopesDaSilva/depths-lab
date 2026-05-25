extends Node2D

@onready var drop_timer: Timer = $"../DropTimer"
@export var limite_gauche: float = -720.0
@export var limite_droite: float = 1100.0
@export var hauteur_plafond: float = -820.0
@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"

const drop_scene = preload("res://scenes/drop_attack.tscn")

var flying : bool = false

	
func start_flying() -> void:
	flying = true
	start_again()

func stop_flying() -> void:
	drop_timer.stop()

func start_again() -> void:
	if flying:
		drop_timer.start()

func _on_drop_timer_timeout() -> void:
	drop_attack()
	start_again()

func drop_attack()-> void:
	var drop = drop_scene.instantiate()
	
	var random_x = randf_range(limite_gauche,limite_droite)
	drop.position = Vector2(random_x,hauteur_plafond)
	
	get_tree().current_scene.add_child(drop)
