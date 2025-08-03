@tool
class_name MarketCard extends Button

const PROPERTY_LABEL_SCENE: PackedScene = preload("res://scenes/maps/market/market_card/property_label/property_label.tscn")

@onready var property_label_container = %PropertyLabelContainer
@onready var name_label = %NameLabel

@export var part_info: PartInfo = null:
	get:
		return part_info
	set(new_part_info):
		if part_info != null and part_info.changed.has_connections():
			part_info.changed.disconnect(_update_part_info_scene)
		part_info = new_part_info
		_update_part_info()

func _update_part_info():
	if part_info != null and !part_info.changed.has_connections():
		part_info.changed.connect(_update_part_info_scene)
	_update_part_info_scene()

func _update_part_info_scene():
	# break out if scene is still loading
	if property_label_container == null:
		return
	for old_child: PropertyLabel in property_label_container.get_children():
		property_label_container.remove_child(old_child)
		old_child.queue_free()
	if part_info == null:
		name_label.text = "no data"
		return
	name_label.text = part_info.name
	for modifier in part_info.modifiers:
		var new_child = PROPERTY_LABEL_SCENE.instantiate()
		new_child.modifier = modifier
		property_label_container.add_child(new_child)

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_part_info()
