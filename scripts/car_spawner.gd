@tool
extends Node2D
class_name CarSpawner

const CAR_SCENE = preload("res://scenes/entities/rigid_car.tscn")
const SEPERATION = 52.0

@export var override_cart_count:int = 5
var _carts: Array[Car] = []

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		var cart_count = override_cart_count
		for i in range(cart_count):
			var c = CAR_SCENE.instantiate()
			c.rigid_body.linear_damp = 4.0
			c.rigid_body.angular_damp = 6.0
			c.position = position + Vector2.RIGHT * SEPERATION * i
			add_child(c)


func _get_thrusters() -> Thrusters:
	return preload("res://scenes/thrusters/thruster_smoke.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		_prepare_carts()
		_add_cars_to_scene_tree.call_deferred()

func _prepare_carts() -> void:
		# Prepare to spawn the carts
		var info = GameData.player_info
		#var launch_info = info.calculate_final_launch_stats()
		#var launch_info = info.base_stats
		var cart_count = info.linked_carts.size()
		if override_cart_count > 0:
			cart_count = override_cart_count
		for i in range(cart_count):
			var c = CAR_SCENE.instantiate()
			if owner is TrackPart:
				c.track_attached = owner
			#add_sibling(c)
			_carts.append(c)
			c.progress = SEPERATION * float(i)
			if i == cart_count-1:
				var cam = Camera2D.new()
				cam.zoom = Vector2.ONE * 0.5
				c.rigid_body.add_child(cam)

				var th = _get_thrusters()
				th.disabled = true
				c.thrusters = th
				c.rigid_body.add_child(th)
		
		# Join the cars together
		var raang = range(_carts.size()-1)
		raang.reverse()
		for i in range(_carts.size()-1):
			var c = _carts[i]
			c.join_to = _carts[i+1]


func _add_cars_to_scene_tree() -> void:
	if !Engine.is_editor_hint():
		for c in _carts:
			add_sibling(c)
			c.add_to_group("player")
			c.rigid_body.add_to_group("player")


func _clear_cars() -> void:
	if !Engine.is_editor_hint():
		for c in _carts:
			c.queue_free()
		_carts.clear()


func reload_cars() -> void:
	_clear_cars()
	_prepare_carts()
	_add_cars_to_scene_tree()
