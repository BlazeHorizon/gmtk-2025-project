@tool
## Class to grab part info for tracks
## class_name TrackFactory
extends Node

var _common_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Common Loop",
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

var _uncommon_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Uncommon Loop",
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

var _rare_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Rare Loop",
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

var _legendary_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Legendary Loop",
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

## stores array matching RarityRandomizer.Rarity enum
var _tracks: Array[Array] = [
		_common_tracks,
		_uncommon_tracks,
		_rare_tracks,
		_legendary_tracks
	]


# TODO: (not required) to help testing add a get_track method to get a specific track?

## Provided a rarity matching RarityRandomizer.Rarity enum return a track
func get_random_track_by_rarity(
	rarity: int = 0
) -> PartInfo:
	var matching_tracks: Array[PartInfo] = _tracks[rarity]
	var random_track_index: int = GlobalRng.rng.randi_range(0, matching_tracks.size() - 1)
	return matching_tracks[random_track_index].duplicate(true)
