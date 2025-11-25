extends State

@export var feint: State
var dist := 0.0
var timer := 0.0
const WAIT_TIME := 2.0

func process_physics(delta: float) -> State:
	var target_position = parent.position
	target_position.y = ball.position.y
	parent.position = parent.position.move_toward(target_position, speed * delta)
	dist = parent.global_position.distance_to(ball.global_position)
	if dist <= 30:
		return feint
	return null
