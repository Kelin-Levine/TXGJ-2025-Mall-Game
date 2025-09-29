class_name SimpleProjectile2D
extends RigidBody2D


@export var damage: float = 10.0
@export var lifespan: float = 5.0

@onready var initial_velocity = linear_velocity


func on_body_entered(body: Node) -> void:
	if body.has_method(&"hurt"):
		body.call(&"hurt", damage, initial_velocity)
	queue_free()


func _ready() -> void:
	body_entered.connect(on_body_entered)
	get_tree().create_timer(lifespan).timeout.connect(queue_free)
