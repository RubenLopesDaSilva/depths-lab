extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var playback = $AnimationTree.get("parameters/StateMachine/playback")

var moving = false

func move() -> void:
	
	if moving == true:
		return
		
	moving = true
	
	await move_forward(9)
	
	$Sprite2D.flip_h = !$Sprite2D.flip_h
	
	$AnimationTree.active = false
	
	
	animation_player.play_backwards("possesed")
	
	await animation_player.animation_finished
	
	animation_player.stop()
	playback.travel("Idle 2");
	$AnimationTree.active = true
	
	moving = false
	
	
	
func move_forward(duration):
	if animation_player.current_animation != "death":
		var speed = 2
		var timer = 0.0
	
		while timer < duration:
			if $Sprite2D.flip_h:
				global_position.x += speed
			else:
				global_position.x -= speed
		
			timer += get_process_delta_time()
			await get_tree().process_frame
