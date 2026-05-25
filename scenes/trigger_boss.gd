extends Area2D

const boss_scene = preload("res://scenes/experiment_215_s.tscn")
@onready var camera_2d: Camera2D = $"../Camera2D"


var temps_ecoule: float = 0.0

func _process(delta: float) -> void:
	if temps_ecoule < 1.0:
		temps_ecoule += delta

func _on_body_entered(body: Node2D) -> void:
	if temps_ecoule < 1.0:
		return
	
	print("Body entered")
	if body.is_in_group("Player"):
		camera_2d.enabled = true
		camera_2d.make_current()
		var boss = boss_scene.instantiate()
		
		boss.position = Vector2(865.0,2)
		boss.scale = Vector2(5,5)
		get_tree().current_scene.call_deferred("add_child",boss)
		
		call_deferred("queue_free")
