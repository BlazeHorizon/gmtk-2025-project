@tool
## Class to grab part info for engine_carts
## class_name EngineCartFactory
extends Node

# TODO: (not required) to help testing add a get_engine_cart method to get a specific engine_cart?

## Provided a rarity matching RarityRandomizer.Rarity enum return a engine_cart
func get_random_engine_cart_by_rarity(
	rarity: int = 0
) -> PartInfo:
	var matching_engine_carts: Array[PartInfo] = _engine_carts[rarity]
	var random_engine_cart_index: int = GlobalRng.rng.randi_range(0, matching_engine_carts.size())
	return matching_engine_carts[random_engine_cart_index].duplicate(true)

## stores array matching RarityRandomizer.Rarity enum
var _engine_carts: Array[Array] = []

func _ready() -> void:
	# stores array matching RarityRandomizer.Rarity enum
	_engine_carts = [
		_common_engine_carts,
		_uncommon_engine_carts,
		_rare_engine_carts,
		_legendary_engine_carts
	]

var STARTING_ENGINE_CART = PartInfo.new(
	"Starting Engine Cart",
	preload("res://icon.svg"),
	[
		PropertyModifier.new(
			LaunchStats.AffectedProperty.SPEED,
			0.5, # amount
			PropertyModifier.CompoundingType.ADDITIVE_FLAT,
		)
	]
)

var _common_engine_carts: Array[PartInfo] = [
	PartInfo.new(
		"Common Engine Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				1.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	)
]

var _uncommon_engine_carts: Array[PartInfo] = [
	PartInfo.new(
		"Uncommon Engine Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				2.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	)
]

var _rare_engine_carts: Array[PartInfo] = [
	PartInfo.new(
		"Rare Engine Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				3.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	)
]

var _legendary_engine_carts: Array[PartInfo] = [
	PartInfo.new(
		"Legendary Engine Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				4.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	)
]
