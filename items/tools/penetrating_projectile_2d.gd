class_name PenetratingProjectile2D
extends Area2D


@export var damage: float = 10.0
@export var lifespan: float = 5.0

var linear_velocity := Vector2.ZERO


func _ready() -> void:
	body_entered.connect(on_body_entered)
	get_tree().create_timer(lifespan).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += linear_velocity * delta


func on_body_entered(body: Node) -> void:
	if body.has_method(&"hurt"):
		body.call(&"hurt", damage, linear_velocity)
