class_name Enemy2D
extends CharacterBody2D


@export var max_health = 50.0

@onready var health = max_health


func hurt(damage: float, knockback: Vector2) -> void:
	health -= damage
	if health <= 0.0:
		queue_free()
	else:
		velocity = knockback
		move_and_slide()
