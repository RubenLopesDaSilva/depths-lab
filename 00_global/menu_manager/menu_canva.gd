extends CanvasLayer

@export var control: Control;

# a enlever juste pour le test
var boss = false;
var boss_id : int = -1;
var chase = false;
var chase_id : int = -1;

func _ready() -> void:
	control.hide();

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if control.visible:
			_close();
		else:
			_show();
	
func _show() -> void:
	get_tree().paused = true;
	control.show();
	
func _close() -> void:
	control.hide();
	get_tree().paused = false;

func _on_play_btn_pressed() -> void:
	_close();

func _on_restart_btn_pressed() -> void:
	GameManager.restart();

func _on_reset_btn_pressed() -> void:
	GameManager.reset();

func _on_exit_btn_pressed() -> void:
	get_tree().quit();
