extends PathFollow2D
class_name Car

@export_flags_2d_physics var collision_layer: int = 1
@export_flags_2d_physics var collision_mask: int = 1
@export var rigid_body: RigidBody2D
@export var pin_joint: Joint2D
@export var join_to: Car
@export var health_component: HealthComponent
@export var cart_noises: AudioStreamPlayer


var track_attached:TrackPart
var speed:float = -1
var end_of_track:bool = false
var _init: bool = false
var thrusters: Thrusters = null
var _off_track: bool = false


func _ready() -> void:
	if owner is TrackPart:
		track_attached = owner
	GameData.launch_train_cars.connect(_on_launch_train_cars)
	health_component.damaged.connect(GameData._on_playercart_damage)


func _on_launch_train_cars() -> void:
	# IF SPEED IS -1 THEN IT IS A NEW CAR AND DOESNT CARE ABOUT KEEPING MOMENTUM
	speed = track_attached.track_speed
	var track: TrackPart = track_attached
	GameData.player_info.placed_tracks.clear()
	# TODO: This needs to be moved to a base place when launch is first triggered
	# currently it is ran for each cart which is bad, they all calculate the same
	# number, but I'm not sure where else to get the starting track before launch
	while track != null:
		print("adding track info to player: ")
		if track.part_info == null:
			print("no part info..., skipping...")
		else:
			print("adding part info...")
			GameData.player_info.placed_tracks.append(track.part_info)
		track = track.track_right
	var current_data = GameData.player_info.calculate_final_launch_stats()
	if thrusters != null:
		thrusters.fuel = current_data.thruster_fuel
		thrusters.power = current_data.thruster_power / 100.0
		cart_noises.play()
	_init = true


func _process(delta: float) -> void:
	if !_init: return

	# MOVE ALONG TRACK
	var next = false;
	var offset = 2.0 * delta * speed
	if !end_of_track:
		var f = progress
		progress += offset
		if f > progress:
			progress_ratio = .999
			next = true
	else:
		position += Vector2(cos(rotation), sin(rotation)) * offset
	
	if rotation_degrees > 10 and !end_of_track:
		# IF FACING DOWN, ACCELERATE
		speed += 1.0 * delta
		speed *= 1.01
	elif rotation_degrees < -10 and !end_of_track:
		# IF FACING UP SLOW DOWN
		speed -= .70 * delta
		speed *= 0.99
	elif speed > track_attached.track_speed:
		speed = lerp(speed, track_attached.track_speed, 0.01)
	
	if !end_of_track:
		# ClAMP THE SPEED WHILE RIDING THE TRACK
		speed = max(speed, 3.0)
	
	if next:
		# WHEN FINISHED TRACK, EITHER STOP OR MOVE TO NEXT TRACK
		if track_attached.track_right:
			track_attached.pass_on_train_car(self, speed)
			# queue_free()
		else:
			# rigid_body.reparent(get_tree().current_scene)
			rigid_body.sleeping = false
			rigid_body.freeze = false
			rigid_body.linear_velocity =  Vector2(cos(rotation), sin(rotation)) * speed * 2.0
			rigid_body.collision_layer = collision_layer
			rigid_body.collision_mask = collision_mask
			if join_to:
				Car._join_bodies.call_deferred(pin_joint, rigid_body, join_to.rigid_body)
			# queue_free()
			if thrusters:
				thrusters.disabled = false
			_init = false
			_off_track = true
			cart_noises.stop()
	
	# Do sound stuff
	cart_noises.pitch_scale = max(speed / 500.0, 0.0)
	

static func _join_bodies(joint: Joint2D, bodyA: PhysicsBody2D, bodyB: PhysicsBody2D):
	joint.node_a = bodyA.get_path()
	joint.node_b = bodyB.get_path()


func _on_health_component_damaged(new_health: int) -> void:
	$ShipClankMedium.pitch_scale = randf_range(0.5, 1.5)
	$ShipClankMedium.play()


func _on_health_component_killed() -> void:
	$ShipClankMedium.pitch_scale = randf_range(0.5, 1.5)
	$Explosion.play()


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	$ShipClankMedium.pitch_scale = randf_range(2.5, 2.75)
	$ShipClankMedium.play()
