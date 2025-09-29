class_name WackyGun
extends ToolBase


@export var spawn_speed: float = 500.0
@export var spawn_marker: Node2D
@export var bullet: PackedScene


func fire() -> void:
	var b = bullet.instantiate()
	b.global_rotation = global_rotation
	b.global_position = spawn_marker.global_position
	b.linear_velocity = Vector2.from_angle(b.rotation) * spawn_speed
	PlayerManager.mall_inst.add_child(b)
	PlayerManager.durability -= 0.01
