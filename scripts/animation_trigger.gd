class_name AnimationTrigger
extends Node

signal triggered(animation_name: String)


@export var animation_name := ""
@export var animation_player: AnimationPlayer

func play(_animation_name := animation_name) -> void:
	if animation_player:
		animation_player.call_deferred("play", _animation_name)
	triggered.emit(_animation_name)
