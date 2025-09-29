class_name Basebat
extends ToolBase


@export var damage: float = 10.0
@export var duration: float = 0.5
@export var knockback: float = 10.0
@export var area: Area2D
@export var collision: CollisionShape2D


func _ready() -> void:
	collision.disabled = true
	area.body_entered.connect(on_hit)


func fire() -> void:
	rotation = -PI/2.0
	PlayerManager.durability -= 0.04
	collision.disabled = false
	await get_tree().create_timer(duration).timeout
	collision.disabled = true
	rotation = 0.0


func on_hit(body: Node2D) -> void:
	if body.has_method(&"hurt"):
		body.call(&"hurt", damage, Vector2(sin(global_rotation), -cos(global_rotation))*knockback)
