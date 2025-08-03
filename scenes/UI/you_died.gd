class_name YouDiedMenu extends Control

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/credits.tscn")

func _on_return_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")

func _on_start_game_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
