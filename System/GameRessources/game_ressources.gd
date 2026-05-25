class_name GameResource
extends Node

signal depleated
signal replenished
signal max_changed(new_max: int)
signal current_changed(new_current: int)
signal is_dead


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var animation_tree: AnimationTree = $"../AnimationTree"

@export var max_amount := 10 : set = set_max_amount
@export var current_amount := 0 : set = set_current_amount


func _ready() -> void:
	replenish();
	max_changed.emit(max_amount)
	current_changed.emit(current_amount)


func set_max_amount(new_max_amount: int) -> void:
	max_amount = new_max_amount
	max_changed.emit(max_amount)
	if current_amount > max_amount:
		current_amount = new_max_amount


func set_current_amount(new_amount: int) -> void:
	current_amount = clampi(new_amount, 0, max_amount)
	current_changed.emit(current_amount)
	if new_amount < 1:
		depleated.emit()
	elif new_amount >= max_amount:
		replenished.emit()


func increase(amount: int) -> void:
	current_amount += amount


func decrease(amount: int) -> void:
	current_amount -= amount


func deplete() -> void:
	current_amount = 0
	is_dead.emit()


func replenish() -> void:
	current_amount = max_amount


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if current_amount > 0:
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE;
		decrease(20);
