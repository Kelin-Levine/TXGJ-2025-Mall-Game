class_name PlayerGiver
extends Node


@export var player: Player
@export var tool: PackedScene


func _ready() -> void:
	player.give_tool(tool.instantiate())
