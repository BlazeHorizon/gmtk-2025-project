extends Control

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/credits.tscn")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/prelaunch_area.tscn")


func _on_button_pressed() -> void:
	get_tree().quit()
