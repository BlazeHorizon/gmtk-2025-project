@tool
## Class to grab part info for tracks
## class_name TrackFactory
extends Node

enum TrackScene {
	UNKNOWN = -1,
	STATION = 0,
	LAUNCHER,
	BASIC,
	DOWN_HILL,
	HILL,
	LOOP,
	
}

var scene_lookup: Dictionary[TrackScene, PackedScene] = {
	TrackScene.STATION: preload("res://scenes/entities/tracks/station_track_part.tscn"),
	TrackScene.LAUNCHER: preload("res://scenes/entities/tracks/launcher_track_part.tscn"),
	TrackScene.BASIC: preload("res://scenes/entities/tracks/basic_track_part.tscn"),
	TrackScene.DOWN_HILL: preload("res://scenes/entities/tracks/down_hill_track_part.tscn"),
	TrackScene.HILL: preload("res://scenes/entities/tracks/hill_track_part.tscn"),
	TrackScene.LOOP: preload("res://scenes/entities/tracks/loop_track_part.tscn"),
}

func get_scene_from_part(part_info: PartInfo, ground_marker: Control) -> TrackPart:
	var track_part_scene: PackedScene = scene_lookup.get(part_info.scene_index as TrackScene)
	if track_part_scene == null:
		return null
	var track_part: TrackPart = track_part_scene.instantiate()
	match part_info.scene_index:
		TrackScene.STATION:
			track_part.track_type = TrackPart.TrackType.BEGINING
		TrackScene.LAUNCHER:
			track_part.track_type = TrackPart.TrackType.ENDING
		_:
			track_part.track_type = TrackPart.TrackType.NORMAL
	track_part.ground_marker = ground_marker
	track_part.part_info = part_info
	return track_part

var _common_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Common Flat",
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.BASIC,
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				1.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	),
	PartInfo.new(
		"Common Slope",
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.DOWN_HILL,
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				1.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	),
	PartInfo.new(
		"Common Hill",
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.HILL,
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				1.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	),
	PartInfo.new(
		"Common Loop",
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.LOOP,
		preload("res://icon.svg"),
		[
			PropertyModifier.new(
				LaunchStats.AffectedProperty.SPEED,
				1.0, # amount
				PropertyModifier.CompoundingType.ADDITIVE_FLAT,
			)
		]
	),
]

var _uncommon_tracks: Array[PartInfo] = [
	PartInfo.new(
		"Uncommon Loop",
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.LOOP,
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
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.LOOP,
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
		PartInfo.Type.TRACK,
		3, # cost
		TrackScene.LOOP,
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
