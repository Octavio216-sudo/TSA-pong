extends Marker2D


var screen_size
func _ready() -> void:
	screen_size = get_viewport().size
	position = Vector2(screen_size.x / 4, screen_size.y / 2)
