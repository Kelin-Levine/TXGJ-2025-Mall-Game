class_name MouseInput
extends Node


@export var mouse_radius: float = 64.0
@export var player: Node2D


func get_mouse_input() -> Vector2:
	var rel_mouse := player.get_global_mouse_position() - player.global_position
	var vec := rel_mouse / mouse_radius
	if vec.length_squared() > 1.0:
		vec = vec.normalized()
	return vec


func _ready() -> void:
	InputManager.set_axis_override(&"aim", get_mouse_input)
