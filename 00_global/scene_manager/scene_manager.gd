extends CanvasLayer

signal load_scene_started
signal new_scene_ready( target_name: String, offset: Vector2 )
signal load_scene_finished
@onready var fade: Control = $fade

func _ready() -> void:
	fade.visible = false;
	await get_tree().process_frame
	await get_tree().process_frame
	load_scene_finished.emit()
	pass


func transition_scene(new_scene: String, target_area: String,player_offset: Vector2,dir: String) -> void:
	var fade_pos : Vector2 = get_fade_pos(dir);
	fade.visible = true;
	
	load_scene_started.emit()
	
	await fade_screen(fade_pos,Vector2.ZERO)
	
	get_tree().change_scene_to_file(new_scene)
	
	await get_tree().scene_changed
	
	new_scene_ready.emit(target_area,player_offset)
	
	await fade_screen(Vector2.ZERO,-fade_pos)
	
	load_scene_finished.emit()
	pass

func fade_screen(from: Vector2, to: Vector2) -> Signal:
	fade.position = from;
	var tween : Tween = create_tween();
	tween.tween_property(fade, "position",to,0.2)
	return tween.finished
	

func get_fade_pos( dir:String ) -> Vector2:
	var pos : Vector2 = Vector2( 1152 *2, 648 * 2);
	match dir:
		"left": 
			pos *= Vector2(-1,0);
		"right": 
			pos *= Vector2(1,0);
		"up":
			pos *= Vector2(0,-1);
		"down":
			pos *= Vector2(0,1);
	return pos
