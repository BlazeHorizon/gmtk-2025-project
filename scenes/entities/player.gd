extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_detector: Area2D = $InteractionDetector


const SPEED = 300.0
const JUMP_VELOCITY = -400.0





func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("prelaunch_interact"):
		var interaction = interaction_detector.get_overlapping_areas()
		if interaction:
			print(interaction[0].building_scene)
		

func _physics_process(delta: float) -> void:

	var direction := Input.get_axis("prelaunch_left", "prelaunch_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()





# Unused portion of CharacterBody2D code template 
