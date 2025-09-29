class_name Mall
extends Node


@export var map: CanvasItem
@export var freddy_five_nights: PackedScene


func _ready() -> void:
	PlayerManager.timeout.connect(spawn_freddy_five_nights)


func spawn_freddy_five_nights() -> void:
	add_child(freddy_five_nights.instantiate())
	map.modulate = Color(0.2, 0.2, 0.2, 1.0)


func kill_freddy_five_nights() -> void:
	map.modulate = Color(1.0, 1.0, 1.0, 1.0)
