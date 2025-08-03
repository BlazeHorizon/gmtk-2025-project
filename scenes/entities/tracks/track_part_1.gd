extends Node2D
class_name TrackPart

enum TrackType {
	NORMAL,
	BEGINING,
	ENDING,
}

# EXPORTED VARs
@export var track_type: TrackType
@export var track_right:NodePath
@export var track_speed:float = 3

@export var ground_marker: Control = null:
	get:
		return ground_marker
	set(new_ground_marker):
		ground_marker = new_ground_marker
		_update_ground_marker()

func _update_ground_marker():
	if track_art != null:
		track_art.ground_marker = ground_marker

# READ-ONLY PROPERTIES
var is_starting_track:bool : 
	get: return track_type == TrackType.BEGINING

var is_ending_track: bool :
	get: return track_type == TrackType.ENDING

# GETTING NODES
@onready var coaster_path: Path2D = $coaster_path
@onready var button: Button = $grab_detect
@onready var track_art: TrackArt = %TrackArt

# SCRIPT VARs
var car_count:int = 5
var grabbed:bool = false
var grab_offset:Vector2 = Vector2.ZERO
var track_delay:float = 0.3
var cars_on_track: Array[Car] = []
var snap_size:int = 64

func _ready() -> void:
	# MAKE SURE SNAPPED
	var x_pos = snapped(position.x, snap_size) 
	var y_pox = snapped(position.y, snap_size)
	position = Vector2(x_pos, y_pox)
	
	GameData.launch_train_cars.connect(_disable_button)
	_update_ground_marker()
	if track_art != null:
		track_art.is_right_connected = !track_right.is_empty()
		
func _disable_button():
	if grabbed:
		_on_grab_detect_button_up()
	button.disabled = true

func spawn_cars():
	# SPAWNS TRAIN CARS
	for i in range(car_count):
		var new_car = generate_new_car()
		grab_train_car(new_car)
		if i == 0:
			var c = Camera2D.new()
			new_car.get_child(0).add_child(c)
			c.position = Vector2.ZERO
			c.enabled = true
			c.make_current()
		
		# SLIGHT DELAY BETWEEN CARs
		await get_tree().create_timer(track_delay).timeout


func _process(_delta: float) -> void:
	if grabbed:
		# WHEN THE MOUSE IS DOWN AND DRAGGING, MOVE WITH IT AND SNAP AND OFFSET
		var x_pos = snapped(get_global_mouse_position().x + grab_offset.x, snap_size) 
		var y_pox = snapped(get_global_mouse_position().y + grab_offset.y, snap_size)
		position = lerp(position, Vector2(x_pos, y_pox), 0.4)
		if track_art != null:
			track_art.update_height()


# RETURNS A NEW TRAIN CAR SCENE
func generate_new_car():
	return preload("res://scenes/entities/rigid_car.tscn").instantiate()

# FOR A TRACK PEICE TO GRAB A TRAIN CAR
func grab_train_car(train_car: Node2D):
	var thing = func() -> void:
		train_car.progress = 0.0
	
	train_car.track_attached = self
	if train_car.get_parent():
		train_car.reparent(coaster_path, true)
		thing.call_deferred()
	else:
		coaster_path.add_child(train_car)
	cars_on_track.append(train_car)

# ALLOWS THIS SCENE TO PASS A NEW CAR TO THE NEXT TRACK
func pass_on_train_car(car, speed):
	if track_right:
		car.speed = speed
		if cars_on_track.has(car):
			cars_on_track.remove_at(cars_on_track.find(car))
		get_node(track_right).grab_train_car(car)

func _on_track_end_area_entered(area: Area2D) -> void:
	# GETS THE TRACK THAT IS IN PROXIMITY FROM AREA 2D
	# LOL SO MANY GET PARENTS 
	if track_right:
		return
	else:
		# MAKES SURE THERES NOT ALREADY A TRACK ATTACHED
		track_right = area.owner.get_path()
		if track_art != null:
			track_art.is_right_connected = true

func _on_track_end_area_exited(area: Area2D) -> void:
	# IF THE TRACK CONNECTED MOVES AWAY, DISCONNECT IT
	# ONLY IF THE TRACK MOVES AWAY WAS THE ONE THAT WAS PREVIOUSLY CONNECTED
	if area.owner.get_path() == track_right:
		track_right = ""
		if track_art != null:
			track_art.is_right_connected = false

func _on_grab_detect_button_down() -> void:
	# WHEN MOUSE DOWN SET GRABBED TO TRUE AND GET OFFSET
	grab_offset = position - get_global_mouse_position()
	grabbed = true

func _on_grab_detect_button_up() -> void:
	# WHEN MOUSE RELASED SET GRABBED TO FALSE
	grabbed = false
	
	# BECAUSE OF THE LERP NEED TO MAKE SURE IT SNAPS WHEN RELEASED AND NOT IN THE MIDDLE OF A LERP
	var x_pos = snapped(get_global_mouse_position().x + grab_offset.x, snap_size) 
	var y_pox = snapped(get_global_mouse_position().y + grab_offset.y, snap_size)
	position = Vector2(x_pos, y_pox)
