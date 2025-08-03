extends CanvasLayer

@export var background_a: Control
@export var background_b: Control

var _camera: Camera2D:
	get: return get_viewport().get_camera_2d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mix = clamp(-_camera.global_position.y / 2000.0, 0.0, 1.0)
	background_a.modulate = Color(1,1,1,mix)
	background_b.modulate = Color(1,1,1,1.0-mix)
	#print(_camera.global_position.y)
	pass
