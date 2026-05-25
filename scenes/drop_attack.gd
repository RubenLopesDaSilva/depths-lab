extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var stateMachine = animation_tree["parameters/playback"]
@export var speed : float = 200.0
var on_ground : bool = false

func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	if not on_ground:
		position.y += speed * delta

func destroy_drop() -> void:
	if on_ground:
		return
	on_ground = true
	
	stateMachine.travel("ground")
	$Area2D/CollisionShape2D.set_deferred("disabled",true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
	destroy_drop()
