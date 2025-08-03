@tool
## This can be carts/tracks we can possibly extend PartInfo into carts and tracks
## as they become more specialized
class_name PartInfo extends Resource

enum Type {
	UNKNOWN = -1,
	TRACK = 0,
	CART = 1,
	ENGINE_CART = 2 # (or rocket, I guess...)
}
## IMPORTANT NOTE: WHEN UPDATED UPDATE THE FOLLOWING:
## scripts/global/cart_factory.gd
## scripts/global/engine_cart_factory.gd
## scripts/global/track_factory.gd

@export var name: String = "":
	get:
		return name
	set(new_name):
		name = new_name
		emit_changed()

@export var type: Type = Type.UNKNOWN:
	get:
		return type
	set(new_type):
		type = new_type
		emit_changed()

@export var cost: int = 0:
	get:
		return cost
	set(new_cost):
		cost = new_cost
		emit_changed()

@export var scene_index: int = 0:
	get:
		return scene_index
	set(new_scene_index):
		scene_index = new_scene_index
		emit_changed()

@export var image: Texture = null:
	get:
		return image
	set(new_image):
		image = new_image
		emit_changed()

@export var modifiers: Array[PropertyModifier] = []:
	get:
		return modifiers
	set(new_modifiers):
		modifiers = new_modifiers
		emit_changed()

func debug_print():
	print("part_name: ", name)
	for modifier in modifiers:
		modifier.debug_print()

func _init(
	p_name: String = "",
	p_type: Type = Type.UNKNOWN,
	p_cost: int = 0,
	p_scene_index: int = -1,
	p_image: Texture = null,
	p_modifiers: Array[PropertyModifier] = []
):
	name = p_name
	type = p_type
	cost = p_cost
	image = p_image
	modifiers = p_modifiers
	scene_index = p_scene_index
