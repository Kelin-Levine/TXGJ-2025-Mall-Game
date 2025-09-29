class_name PlayerGiver
extends Node


@export var player: Player
@export var tool: PackedScene


func _ready() -> void:
	player.give_tool(tool.instantiate())
	await get_tree().create_timer(2.0).timeout
	player.give_tool(tool.instantiate())
