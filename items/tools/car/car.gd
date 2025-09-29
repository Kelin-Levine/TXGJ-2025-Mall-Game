class_name Car
extends ToolBase


@export var spawn_speed: float = 1000.0
@export var bullet: PackedScene


func fire() -> void:
	var b = bullet.instantiate()
	b.global_rotation = global_rotation
	b.global_position = global_position
	b.linear_velocity = Vector2.from_angle(b.rotation) * spawn_speed
	PlayerManager.mall_inst.add_child(b)
	PlayerManager.durability -= 0.1
