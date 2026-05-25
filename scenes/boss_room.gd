extends Node2D
@onready var camera_2d: Camera2D = $Camera2D

var is_dead : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_dead:
		_on_combat_termine()

func _on_combat_termine() -> void:
	camera_2d.enabled = false
