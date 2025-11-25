extends MultiplayerSpawner

@export var net_player: PackedScene
var left_spawn
var right_spawn
var spawn_toggle := true  # true = left, false = right

func _ready() -> void:
	left_spawn = get_parent().get_node("Left")
	right_spawn = get_parent().get_node("Right")
	spawn_function = spawn_player
	multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(id: int) -> void:
	if !multiplayer.is_server():
		return
	var spawn_point = left_spawn if spawn_toggle else right_spawn
	spawn_toggle = !spawn_toggle
	spawn({ "peer_id": id, "position": spawn_point.global_position })

func spawn_player(data: Dictionary) -> Node:
	var peer_id: int = data["peer_id"]
	var spawn_position: Vector2 = data["position"]
	var player := net_player.instantiate()
	player.name = str(peer_id)
	player.global_position = spawn_position
	player.set_multiplayer_authority(peer_id)
	player.add_to_group("paddle")
	var viewport_width = get_viewport().size.x
	if player.global_position.x > viewport_width / 2:
		player.get_node("Paddle_image").self_modulate = Color.WHITE
	else:
		player.get_node("Paddle_image").self_modulate = Color.BLACK
	return player
