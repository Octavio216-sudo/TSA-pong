extends State

@export var screen_size: Vector2
@export var right_edge: Vector2
@export var random_place: float
@export var enemy_collision: bool
@export var defensive: State
var dist
var timer := 0.0
const WAIT_TIME := 1.0
var target_position: Vector2
@export var prediction_time := 4  # seconds ahead to predict
var charging := false
var enemy_hit := false
var speed_up: float
var rotation_delta: float = 0
var current_rotation: float = 0
var is_moving

func enter() -> void:
	speed = 0
	timer = 0.0
	charging = false
	enemy_hit = false  # ← Reset this too!
	screen_size = get_viewport().size
	random_place = randf_range(200, screen_size.y - 200)
	right_edge = Vector2(screen_size.x - 50, random_place)
	target_position = right_edge
	charge_time.timeout.connect(_on_charge_time_timeout)


func process_physics(delta: float) -> State:
	is_it_moving()
	var to_ball = ball.global_position - parent.global_position
	var angle = to_ball.angle()
	parent.rotation = lerp_angle(parent.rotation, angle, delta * 0.3)
	current_rotation = parent.rotation
	timer += delta
	if timer >= WAIT_TIME:
		speed = 800
	dist = parent.position.distance_to(ball.position)
	if enemy_coll():
		enemy_hit = true
	if enemy_hit and wall.ball_passed and not charging:
		charging = true
	if charging:
		target_position = ball.position  # ← live update every frame
		if dist <= 30:
			ball.speed = min(ball.speed + 300, 600)
			return defensive
	else:
		target_position = right_edge
	parent.position = parent.position.move_toward(target_position, speed * delta)
	return null

func enemy_coll() -> bool:
	return enemy.position.distance_to(ball.position) <= 70

func is_it_moving() -> void:
	is_moving = parent.velocity.length() > 0 or rotation_delta > 0.001
	if is_moving and !charge_time.is_stopped():
		pass  # timer already running
	elif is_moving:
		charge_time.start(0.2)  # start 1-second timer
	else:
		speed_up = 0
		charge_time.stop()

func _on_charge_time_timeout() -> void:
	if is_moving:
		speed_up = min(speed_up + 100, 300)
		charge_time.start(0.2)  # restart timer for next second
