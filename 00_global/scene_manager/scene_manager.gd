extends CanvasLayer

signal load_scene_started
signal transition_requested(scene_path:String, target_name:String, offset:Vector2, dir:String)
signal new_scene_ready(target_name:String, offset:Vector2)
signal load_scene_finished

@onready var fade: Control = $fade


func _ready() -> void:
	fade.visible = false
	load_scene_finished.emit()


func transition_scene(
	new_scene:String,
	target_area:String,
	player_offset:Vector2,
	dir:String
) -> void:

	var fade_pos := get_fade_pos(dir)

	fade.visible = true

	load_scene_started.emit()

	await fade_screen(fade_pos, Vector2.ZERO)

	transition_requested.emit(
		new_scene,
		target_area,
		player_offset,
		dir
	)


func finish_transition(
	target_area:String,
	player_offset:Vector2,
	dir:String
) -> void:

	var fade_pos := get_fade_pos(dir)

	new_scene_ready.emit(target_area, player_offset)

	await fade_screen(Vector2.ZERO, -fade_pos)

	fade.visible = false

	load_scene_finished.emit()


func fade_screen(from:Vector2, to:Vector2) -> Signal:
	fade.position = from

	var tween := create_tween()

	tween.tween_property(
		fade,
		"position",
		to,
		0.2
	)

	return tween.finished


func get_fade_pos(dir:String) -> Vector2:

	var pos := Vector2(1152 * 2, 648 * 2)

	match dir:
		"left":
			pos *= Vector2(-1,0)
		"right":
			pos *= Vector2(1,0)
		"up":
			pos *= Vector2(0,-1)
		"down":
			pos *= Vector2(0,1)

	return pos
