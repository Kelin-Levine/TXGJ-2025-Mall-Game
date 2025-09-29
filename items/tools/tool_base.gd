@abstract
class_name ToolBase
extends Node2D


const gravity := 300

var discarded := false
var discard_lin_vel := Vector2(randf_range(-300.0, 300.0), -randf_range(20.0, 400.0))
var discard_ang_vel := randf_range(-1, 1)*PI*10.0


@abstract func fire() -> void


func _physics_process(delta: float) -> void:
	if discarded:
		global_position += (discard_lin_vel * delta)
		rotate(discard_ang_vel * delta)
		discard_lin_vel.y += gravity * delta


func discard() -> void:
	discarded = true
	get_tree().create_timer(5.0).timeout.connect(queue_free)
