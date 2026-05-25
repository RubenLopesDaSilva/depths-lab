extends Node2D
class_name Spawner

signal created(product: Node2D)

const saw = preload("res://scenes/saw_attack.tscn")

@export var common_ancestor_name: StringName
@export var target_container_name: StringName

func create() -> void:
	var product = saw.instantiate();
	if %Visual.scale.x == 1:
		product.global_position.x = global_position.x - 200;
		product.global_position.y = global_position.y;
	else:
		product.global_position.x = global_position.x + 200;
		product.global_position.y = global_position.y;
	var container: Node2D
	if common_ancestor_name:
		container = find_parent(common_ancestor_name)
	if target_container_name:
		container = container.find_child(target_container_name)
	if not container:
		container = self
	get_tree().current_scene.add_child(product);
	var saw_dir = Vector2.LEFT if %Visual.scale.x > 0 else Vector2.RIGHT
	product.set_direction(saw_dir)

	created.emit(product);
