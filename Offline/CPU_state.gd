extends Node
class_name State

@export var animation_name: String
@export var speed: float = 800
@export var ball: Node2D
@export var enemy: CharacterBody2D
@export var wall: StaticBody2D
@export var charge_time: Timer
## A reference to the parent Player node
var parent: CPU

func enter() -> void:
	pass

func exit() -> void:
	pass


func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
