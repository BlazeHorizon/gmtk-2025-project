extends Camera2D

@export var panning_speed: int

var direction: Vector2


func _process(delta: float) -> void:
	
	direction.x = Input.get_axis("prelaunch_left", "prelaunch_right")
	direction.y = Input.get_axis("prelaunch_up", "prelaunch_down")
	
	if direction != Vector2.ZERO:
		position += direction * panning_speed * delta
