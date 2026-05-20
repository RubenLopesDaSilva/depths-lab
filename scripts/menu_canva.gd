extends CanvasLayer

@export var control: Control;

func _ready() -> void:
	control.hide();

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if control.visible:
			_close();
		else:
			_show();
	
func _show() -> void:
	get_tree().paused = true;
	control.show();
	
func _close() -> void:
	get_tree().paused = false;
	control.hide();
