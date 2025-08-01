extends Camera2D

@export var panning_speed: int
@export var zoom_max: Vector2
@export var zoom_min: Vector2
var direction: Vector2



func _process(delta: float) -> void:
	
	direction.x = Input.get_axis("prelaunch_left", "prelaunch_right")
	direction.y = Input.get_axis("prelaunch_up", "prelaunch_down")
	
	if direction != Vector2.ZERO:
		position += direction * panning_speed * delta
		
# Code to zoom camera in and out during gameplay. 
	if Input.is_action_just_pressed("prelaunch_scroll_down") and zoom > zoom_min:
		zoom -= Vector2(0.20, 0.20)
	if Input.is_action_just_pressed("prelaunch_scroll_up") and zoom < zoom_max:
		zoom += Vector2(0.20, 0.20)

## The car has it's own camera built in, maybe best to queue_free this camera 
## so that one takes over after launch? Something like this:
#func _on_launch_pressed() -> void:
#	queue_free()
