extends Area2D
class_name GravityField2D

signal car_landed()

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name, " Type:", body.get_class())
	var gc = GravityComponent.get_gravity_component(body)
	if gc:
		gc.center_point = gravity_point_center
		gc.gravity_force = gravity
		gc.in_gravity_field = true
	
	if body is RigidBody2D:
		var speed = body.linear_velocity.length()
		print("Speed:", speed)
		if speed <= 1:
			print_debug("DEBUG: '%s' entered gravity field and is stopped." % body.name)
		car_landed.emit()


func _on_body_exited(body: Node2D) -> void:
	var gc = GravityComponent.get_gravity_component(body)
	if gc:
		gc.gravity_force = 0.0
		gc.in_gravity_field = false
