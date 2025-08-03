@tool
## Class to grab part info for carts
## class_name CartFactory
extends Node

var _common_carts: Array[PartInfo] = [
	PartInfo.new(
		"Common Passenger Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(), # base speed = 1
			PropertyModifier.new(
				LaunchStats.AffectedProperty.FUN,
				1.0
				# default = PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			),
			PropertyModifier.new(
				LaunchStats.AffectedProperty.PASSENGER_COUNT,
				2.0
			)
		]
	)
]

var _uncommon_carts: Array[PartInfo] = [
	PartInfo.new(
		"Uncommon Passenger Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(), # base speed = 1
			PropertyModifier.new(
				LaunchStats.AffectedProperty.FUN,
				2.0
			)
		]
	)
]

var _rare_carts: Array[PartInfo] = [
	PartInfo.new(
		"Rare Passenger Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				2.0
			),
			PropertyModifier.new(
				LaunchStats.AffectedProperty.FUN,
				30.0,
				PropertyModifier.CompoundingType.ADDITIVE_PERCENTAGE
			)
		]
	)
]

var _legendary_carts: Array[PartInfo] = [
	PartInfo.new(
		"Legendary Passenger Cart",
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				4.0
			),
			PropertyModifier.new(
				LaunchStats.AffectedProperty.FUN,
				100.0,
				PropertyModifier.CompoundingType.ADDITIVE_PERCENTAGE
			)
		]
	)
]

## stores array matching RarityRandomizer.Rarity enum
var _carts: Array[Array] = [
		_common_carts,
		_uncommon_carts,
		_rare_carts,
		_legendary_carts
	]

# TODO: (not required) to help testing add a get_card method to get a specific cart?
	
## Provided a rarity matching RarityRandomizer.Rarity enum return a cart
func get_random_cart_by_rarity(
	rarity: int = 0
) -> PartInfo:
	var matching_carts: Array[PartInfo] = _carts[rarity]
	var random_cart_index: int = GlobalRng.rng.randi_range(0, matching_carts.size() - 1)
	return matching_carts[random_cart_index].duplicate(true)
