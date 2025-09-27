class_name MouseInput
extends Node


@export var mouse_radius: float = 64.0
@export var player: CanvasItem


func get_mouse_input() -> Vector2:
	var vec := player.get_local_mouse_position() / mouse_radius
	if vec.length_squared() > 1.0:
		vec = vec.normalized()
	return vec


func _ready() -> void:
	InputManager.set_axis_override(&"aim", get_mouse_input)
