extends MultiplayerSpawner


@export var net_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var player: Node = net_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
