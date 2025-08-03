@tool
extends Node2D
class_name Thrusters

const FORCE = 3000.0

var body: RigidBody2D:
	get: return get_parent()

var disabled: bool = false
var fuel = 100.0
var power = 1.0
var _wish_direction: Vector2
var _thrusting: bool = false:
	set(v):
		_thrusting = v
		if _thrusting:
			for n: Node in get_children():
				if n is AudioStreamPlayer2D:
					n.play()
		if !_thrusting:
			for n: Node in get_children():
				if n is AudioStreamPlayer2D:
					n.stop()


func _ready():
	GameData.launch_train_cars.connect(_on_launch)
	if !Engine.is_editor_hint():
		if body is not RigidBody2D:
			push_error("Parent is not a RigidBody2D!")

func _on_launch():
	pass

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Input
	_thrusting = !disabled && !is_zero_approx(fuel) && Input.is_action_pressed("launch.activate_thrust")
	if _thrusting:
		_wish_direction = (get_global_mouse_position() - global_position).normalized()

	# Particle effects
	for n: Node in get_children():
		if n is CPUParticles2D:
			n.global_rotation = 0.0
			n.emitting = _thrusting
			n.direction = -_wish_direction


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Thrusting
	if _thrusting:
		if body is RigidBody2D && !_wish_direction.is_zero_approx():
			body.apply_central_force(FORCE * _wish_direction * power)
		fuel -= delta


func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not RigidBody2D:
		return["Parent must be a RigidBody2D!"]
	return []
	

# I like the way you thrust, Cloud!
#	- AoS
