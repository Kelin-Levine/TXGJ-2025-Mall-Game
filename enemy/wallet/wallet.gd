class_name Wallet
extends Area2D


@export var value := 10.0
@export var pickup_label: PackedScene


func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if body is Player:
		PlayerManager.money += value
		spawn_label()
		queue_free()


func spawn_label() -> void:
	var label := pickup_label.instantiate()
	label.global_position = global_position
	label.text = "+$" + str(value).pad_decimals(2)
	label.self_modulate = Color(0.0, 1.0, 0.0, 1.0)
	PlayerManager.mall_inst.add_child(label)
