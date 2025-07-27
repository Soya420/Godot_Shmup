extends Control


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_guide_button_pressed():
	get_tree().change_scene_to_file("")


func _on_exit_button_pressed():
	get_tree().quit()
