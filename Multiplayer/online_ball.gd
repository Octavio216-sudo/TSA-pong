extends StaticBody2D

@onready var speed_timer: Timer = $speed_timer
var screen_size: Vector2
var dir = get_ran_dir()
var speed = 100
var out_bounds: bool = false
var middle = Vector2()
var high: bool
var low: bool
var can_collide := true
const MAX_SPEED = 600
const MIN_SPEED = 100

@onready var paddle
@onready var physics: Node = $Ball_physics
@onready var slow_timer: Timer = $slow_timer
var reference_speed: float = 0
var velocity := Vector2.ZERO
var old_position = position
var speed_up: float

func _ready() -> void:
	if !is_multiplayer_authority(): return

	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	old_position = position

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	var new_position = position
	velocity = (new_position - old_position) / delta
	var collision = move_and_collide(dir * speed * delta)
	if can_collide and collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if collider != paddle:
			speed = min(speed * 1.2, MAX_SPEED)
			dir = dir.bounce(normal)
			reference_speed = min(reference_speed + 15, reference_speed + 15)
			print(reference_speed)
		elif collider == paddle:
			print("collide")
			if paddle.speed_up >= 0:
				speed = min(speed + paddle.speed_up, MAX_SPEED)
			else:
				speed = min(speed * 1.2, MAX_SPEED)
			position += normal * 4
			dir = dir.bounce(normal)
			reference_speed = min(reference_speed + 15, reference_speed + 15)
			slow_down()
			temp_pause()
	position_tracking()

func temp_pause() -> void:
	if !is_multiplayer_authority(): return
	paddle.rotation_speed = 0
	can_collide = false
	speed_timer.start()

func slow_down() -> void:
	if !is_multiplayer_authority(): return
	slow_timer.start(.2)

func _on_slow_timer_timeout() -> void:
	if !is_multiplayer_authority(): return
	speed = clamp(speed - 25, MIN_SPEED + reference_speed, MAX_SPEED)
	slow_timer.start(.2)

func _on_speed_timer_timeout() -> void:
	if !is_multiplayer_authority(): return
	paddle.rotation_speed = 7
	can_collide = true

func get_ran_dir() -> Vector2:
	var new_dir = Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = [1, -1].pick_random()
	return new_dir.normalized()


func position_tracking() -> void:
	if !is_multiplayer_authority(): return
	high = position.x >= screen_size.x / 1.01 or position.y >= screen_size.y 
	low = position.x <= -60 or position.y <= -screen_size.y
	middle = Vector2(screen_size.x / 2, screen_size.y / 2)
	screen_size = get_viewport_rect().size
	if high or low:
		print(screen_size.x)
		reference_speed = 0
		position = middle
		speed = MIN_SPEED
