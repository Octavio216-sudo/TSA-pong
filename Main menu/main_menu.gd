extends Node



func _on_local_online_pressed() -> void:
	get_tree().change_scene_to_file("res://Multiplayer/Multi-menu.tscn")


func _on_offline_pressed() -> void:
	get_tree().change_scene_to_file("res://Offline/Offline map.tscn")
