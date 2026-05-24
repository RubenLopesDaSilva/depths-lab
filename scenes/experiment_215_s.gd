extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var playback = $AnimationTree.get("parameters/StateMachine/playback")
var idle_finished_count = 0;
var moving = false

func move() -> void:
	
	if moving == true:
		return;
		
	moving = true
	
	await move_forward(4)
	
	%Visual.scale.x *= -1
	
	playback.travel("possesed_reverse")
	
	while playback.get_current_node() != "Idle 2":
		await get_tree().process_frame
	
	
	moving = false
	
	
	
func move_forward(duration):
	if animation_player.current_animation != "death":
		var speed = 2
		var timer = 0.0
	
		while timer < duration:
			if %Visual.scale.x == -1:
				global_position.x += speed
			else:
				global_position.x -= speed
		
			timer += get_process_delta_time()
			await get_tree().process_frame
			



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	idle_finished_count += 1
	print("Idle animation finished: ", idle_finished_count, " times")
	if(idle_finished_count >= 2):
		playback.travel("sawAttack")
		idle_finished_count = 0
