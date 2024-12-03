extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/levels/rooms/scene_1/scene_1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/game/ui/main_principal/scene/option.tscn")


func _on_button_3_pressed():
	get_tree().quit()
