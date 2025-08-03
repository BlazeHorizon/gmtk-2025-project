@tool
## This can be carts/tracks we can possibly extend PartInfo into carts and tracks
## as they become more specialized
class_name PartInfo extends Resource


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
	p_image: Texture = null,
	p_modifiers: Array[PropertyModifier] = []
):
	name = p_name
	image = p_image
	modifiers = p_modifiers
