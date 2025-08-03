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
			c.position = position + Vector2.RIGHT * SEPERATION * i
			add_child(c)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		# Prepare to spawn the carts
		var info = GameData.player_info
		#var launch_info = info.calculate_final_launch_stats()
		var launch_info = info.base_stats
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

				var th = Thrusters.new()
				th.fuel = launch_info.thruster_fuel
				th.power = launch_info.thruster_power / 100.0
				c.rigid_body.add_child(th)
		
		# Join the cars together
		var raang = range(_carts.size()-1)
		raang.reverse()
		for i in range(_carts.size()-1):
			var c = _carts[i]
			c.join_to = _carts[i+1]
	_spawn_cars.call_deferred()


func _spawn_cars() -> void:
	if !Engine.is_editor_hint():
		for c in _carts:
			add_sibling(c)
