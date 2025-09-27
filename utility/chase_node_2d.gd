class_name ChaseNode2D
extends Node2D


@export var rate: float
@export var target: Node2D


func scale_time(delta: float) -> float:
	return -exp(-rate*delta)+1


func _process(delta: float) -> void:
	var scaled := scale_time(delta)
	var dist := (target.global_position - global_position).limit_length(scaled)
	global_position += dist
