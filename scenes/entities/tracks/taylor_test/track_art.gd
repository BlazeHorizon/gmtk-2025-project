@tool
class_name TrackArt extends Control

@onready var beam_art_mask: Panel = %BeamArtMask
@onready var beam_art: Panel = %BeamArt
@onready var point_converter: Node2D = %PointConverter
@onready var left_beam: Panel = %LeftBeam
@onready var right_beam: Panel = %RightBeam
@onready var left_beam_container: Control = %LeftBeamContainer
@onready var right_beam_container: Control = %RightBeamContainer
@onready var track_path_art_behind: TextureRect = %TrackPathArtBehind
@onready var track_path_art_in_front: TextureRect = %TrackPathArtInFront

@export var ground_marker: Control = self:
	get:
		return ground_marker
	set(new_ground_marker):
		ground_marker = new_ground_marker
		update_height()

@export var left_beam_marker: Node2D = null
@export var right_beam_marker: Node2D = null

@export var is_right_connected: bool = false:
	get:
		return is_right_connected
	set(new_is_right_connected):
		is_right_connected = new_is_right_connected
		_update_is_right_connected()

func _update_is_right_connected():
	if right_beam == null:
		return
	if is_right_connected:
		right_beam.hide()
	else:
		right_beam.show()

@export var style_box_mask: StyleBox = null:
	get:
		return style_box_mask
	set(new_style_box_mask):
		style_box_mask = new_style_box_mask
		_update_style_box_mask()

func _update_style_box_mask():
	if beam_art_mask == null or style_box_mask == null:
		return
	beam_art_mask.add_theme_stylebox_override("panel", style_box_mask)

@export var debug_mask_layer: bool = false:
	get:
		return debug_mask_layer
	set(new_debug_mask_layer):
		debug_mask_layer = new_debug_mask_layer
		_update_debug_mask_layer()

func _update_debug_mask_layer():
	if beam_art_mask == null or style_box_mask == null:
		return
	beam_art_mask.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW if debug_mask_layer else CanvasItem.CLIP_CHILDREN_ONLY

@export var track_path_art_behind_texture: Texture = null:
	get:
		return track_path_art_behind_texture
	set(new_track_path_art_behind_texture):
		track_path_art_behind_texture = new_track_path_art_behind_texture
		_update_track_path_art_behind()

func _update_track_path_art_behind():
	if track_path_art_behind == null or track_path_art_behind_texture == null:
		return
	track_path_art_behind.texture = track_path_art_behind_texture

@export var track_path_art_in_front_texture: Texture = null:
	get:
		return track_path_art_in_front_texture
	set(new_track_path_art_in_front_texture):
		track_path_art_in_front_texture = new_track_path_art_in_front_texture
		_update_track_path_art_in_front()

func _update_track_path_art_in_front():
	if track_path_art_in_front == null or track_path_art_in_front_texture == null:
		return
	track_path_art_in_front.texture = track_path_art_in_front_texture

func _ready() -> void:
	left_beam.show()
	_update_style_box_mask()
	_on_resized()
	_update_track_path_art_behind()

func _on_resized() -> void:
	_update_mask_size()
	_update_beam_art_size()
	_update_side_beam_positions()
	

func _update_mask_size() -> void:
	var x_remainder: float = fmod(size.x, 32)
	var new_x = size.x - x_remainder
	beam_art_mask.size = Vector2(new_x, size.y)
	beam_art_mask.position = Vector2.ZERO

func _update_beam_art_size() -> void:
	var scaled_size = size * 2
	var x_remainder: float = fmod(scaled_size.x, 64)
	var y_remainder: float = fmod(scaled_size.y, 128)
	var new_x = scaled_size.x - x_remainder
	var new_y_art_offset = -128 + y_remainder
	var new_y = scaled_size.y + 128 - y_remainder
	beam_art.size = Vector2(new_x, new_y)
	beam_art.position = Vector2(0, new_y_art_offset / 2)

func _update_side_beam_positions() -> void:
	if left_beam_marker == null or right_beam_marker == null:
		return
	var local_beam_right_position = point_converter.to_local(right_beam_marker.global_position)
	print("right_beam.x: ", local_beam_right_position.x, ", right_beam.y: ", local_beam_right_position.y)
	var local_beam_left_position = point_converter.to_local(left_beam_marker.global_position)
	print("left_beam.x: ", local_beam_left_position.x, ", left_beam.y: ", local_beam_left_position.y)
	left_beam.position = Vector2(-16, -24)
	left_beam_container.position = local_beam_left_position
	right_beam.position = Vector2(-16, -24)
	right_beam_container.position = local_beam_right_position


func update_height() -> void:
	if ground_marker == self or ground_marker == null or point_converter == null:
		return
	var local_point_top = point_converter.to_local(global_position)
	var local_point_bottom = point_converter.to_local(ground_marker.global_position)
	var new_height: float =  absf(local_point_top.y - local_point_bottom.y) + 64
	if size.y == new_height:
		return
	else:
		_update_side_beam_heights(new_height)
		size.y = new_height

func _update_side_beam_heights(new_height: float) -> void:
	if left_beam_marker == null or right_beam_marker == null:
		return
	left_beam.size.y = (new_height - left_beam_container.position.y) * 2 + 48
	right_beam.size.y = (new_height - right_beam_container.position.y) * 2 + 48
#
#func _process(delta: float) -> void:
	#update_height()
