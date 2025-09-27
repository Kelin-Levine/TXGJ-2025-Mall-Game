class_name WackyGun
extends ToolBase


@export var spawn_speed: float = 500.0
@export var spawn_marker: Node2D
@export var bullet: PackedScene


func fire() -> void:
	var b = bullet.instantiate()
	b.rotation = rotation
	b.position = spawn_marker.global_position
	b.linear_velocity = Vector2.from_angle(b.rotation) * spawn_speed
	get_tree().root.add_child(b)
