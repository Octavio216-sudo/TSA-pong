extends Control


func _on_host_pressed() -> void:
	NetHandler.start_server()


func _on_join_pressed() -> void:
	NetHandler.start_client()
