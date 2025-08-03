@tool
class_name PropertyLabel extends MarginContainer

@onready var value_label = %ValueLabel
@onready var type_label = %TypeLabel

@export var modifier: PropertyModifier = null:
	get:
		return modifier
	set(new_modifier):
		if modifier != null and modifier.changed.has_connections():
			modifier.changed.disconnect(_update_modifier_scene)
		modifier = new_modifier
		_update_modifier()

func _update_modifier():
	if modifier != null and !modifier.changed.has_connections():
		modifier.changed.connect(_update_modifier_scene)
	_update_modifier_scene()

func _update_modifier_scene():
	_update_value_label()
	_update_type_label()
	
func _update_value_label():
	if value_label == null:
		return
	if modifier == null:
		value_label.text = ""
		return
	var prefix = ""
	var postfix = ""
	match modifier.compounding_type:
		PropertyModifier.CompoundingType.ADDITIVE_FLAT:
			prefix = "+" if modifier.amount >= 0 else ""
		PropertyModifier.CompoundingType.ADDITIVE_PERCENTAGE:
			prefix = "+" if modifier.amount >= 0 else ""
			postfix = "%"
		PropertyModifier.CompoundingType.MULTIPLICATIVE:
			prefix = "x"
	value_label.text = str(prefix, modifier.amount, postfix)

func _update_type_label():
	if type_label == null:
		return
	if modifier == null:
		type_label.text = "empty"
		type_label.modulate = Color.WHITE
		return
	var affected_property_data: LaunchStats.PropertyData = LaunchStats.affected_property_data_lookup.get(modifier.affected_property)
	if affected_property_data == null:
		return
	type_label.text = affected_property_data.display_text
	type_label.modulate = affected_property_data.display_color
	

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_modifier()
