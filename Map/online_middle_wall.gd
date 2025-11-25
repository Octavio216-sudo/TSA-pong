extends StaticBody2D
@onready var ball
@export var ball_passed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = get_parent().get_node("Online_ball")
	add_collision_exception_with(ball)
	position.x = get_viewport().size.x / 2

func _physics_process(delta: float) -> void:
	if ball.position.x >= position.x:
		ball_passed = true
	else:
		ball_passed = false
