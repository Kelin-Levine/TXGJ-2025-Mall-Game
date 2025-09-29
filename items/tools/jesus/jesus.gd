class_name Jesus
extends ToolBase


@export var standing: PackedScene


func fire() -> void:
	var b = standing.instantiate()
	b.global_position = global_position
	PlayerManager.mall_inst.add_child(b)
	PlayerManager.durability -= 1.0
