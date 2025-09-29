class_name Shimmer
extends Node


@export var interval_msec := 1000

var target: CanvasItem


func _ready() -> void:
	target = get_parent()


func _process(_delta: float) -> void:
	var col := sin(float(Time.get_ticks_msec() % interval_msec) / interval_msec * PI)
	target.self_modulate = Color(1.0, 1.0, col, 1.0)
