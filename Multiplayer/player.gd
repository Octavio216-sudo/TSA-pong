extends CharacterBody2D

@onready var charge_time: Timer = $charge_time

@onready var ball
const SPEED = 300.0
@export var rotation_speed = 7 # Speed of rotation
var speed_up: float = 0
var is_moving: bool = false
var rotation_delta: float = 0
var current_rotation: float = 0
@onready var paddle_image: Sprite2D = $Paddle_image
var paddle_pos: Vector2
var white: Color = Color(1, 1, 1)
var black: Color = Color(0, 0, 0)

func _multiplayer_spawned() -> void:
	if !is_multiplayer_authority(): return

	charge_time.timeout.connect(on_charge_timeout)


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	current_rotation = rotation
	var direction := Input.get_axis("Left", "Right")
	var direction_hor := Input.get_axis("up", "down")
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
	velocity.y = direction_hor * SPEED if direction_hor else move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	if Input.is_action_pressed("Rotate clockwise"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("Rotate counter clockwise"):
		rotation += rotation_speed * delta
	
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider == ball:
			ball.speed = min(ball.speed + 300, 600)
	is_it_moving()

func is_it_moving() -> void:
	if !is_multiplayer_authority(): return
	rotation_delta = abs(rotation - current_rotation)
	is_moving = velocity.length() > 0 or rotation_delta > 0.001
	if is_moving and !charge_time.is_stopped():
		pass  # timer already running
	elif is_moving:
		charge_time.start(0.2)  # start 1-second timer
	else:
		speed_up = 0
		charge_time.stop()

func on_charge_timeout() -> void:
	if !is_multiplayer_authority(): return
	if is_moving:
		speed_up = min(speed_up + 100, 300)
		charge_time.start(0.2)  # restart timer for next second
