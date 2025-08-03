extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect

enum actions {change_scene, hide}

@export var finished_action:actions = actions.hide
@export var change_scene_to:PackedScene
@export var cut_scene:CutsceneFrames
var changing_scene:bool = false

func _ready() -> void:
	if cut_scene:
		texture_rect.texture = cut_scene.frames[0]

func _on_next_slide_pressed() -> void:
	var next_frame = cut_scene.get_next_frame()
	if next_frame == null:
		animation_player.play("fade")
		await animation_player.animation_finished
		if finished_action == actions.hide:
			queue_free()
		if finished_action == actions.change_scene and changing_scene == false:
			changing_scene = true
			get_tree().change_scene_to_packed(change_scene_to)
	else:
		texture_rect.texture = next_frame
