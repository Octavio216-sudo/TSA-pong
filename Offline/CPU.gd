# Player.gd
class_name CPU
extends CharacterBody2D

@onready var state_machine: Node = $CPU_FSM
@onready var physics: CollisionShape2D = $Paddle_physics
@onready var ball = get_parent().get_node("offline_ball")
@onready var enemy = get_parent().get_node("Offlinepaddle")
@onready var wall = get_parent().get_node("Middle wall")
@onready var charge_time = get_parent().get_node("CPU/charge_time")

func _ready() -> void:
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func game_over():
	pass

func start_over():
	get_tree().change_scene_to_file("res://Main menu/Main menu.tscn")
