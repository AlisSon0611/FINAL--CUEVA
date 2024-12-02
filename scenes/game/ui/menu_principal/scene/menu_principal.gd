extends Node

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/levels/rooms/scene_3/scene_3.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/game/ui/menu_principal/scene/opciones.tscn")


func _on_button_3_pressed():
	get_tree().quit()
