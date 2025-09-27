class_name SimpleProjectile2D
extends RigidBody2D


@export var damage: float = 10.0
@export var lifespan_msec: int = 5000

@onready var initial_velocity = linear_velocity
@onready var spawn_time = Time.get_ticks_msec()


func on_body_entered(body: Node) -> void:
	if body.has_method(&"hurt"):
		body.call(&"hurt", damage, initial_velocity)
	queue_free()


func _ready() -> void:
	body_entered.connect(on_body_entered)


func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() > spawn_time + lifespan_msec:
		queue_free()
