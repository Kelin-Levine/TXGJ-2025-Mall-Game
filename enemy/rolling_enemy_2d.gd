class_name RollingEnemy2D
extends Enemy2D


@export var rolling_timer: Timer

var direction := Vector2.ZERO


func _ready() -> void:
	super._ready()
	reset_direction()
	rolling_timer.timeout.connect(reset_direction)


func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		var progress := sin(rolling_timer.time_left / rolling_timer.wait_time * PI)
		velocity = progress * speed * direction * 2.0
		move_and_slide_and_shove()


func reset_direction() -> void:
	var player := PlayerManager.inst
	if player != null:
		var diff := player.global_position - global_position
		rotation = diff.angle()
		direction = diff.normalized()
	else:
		direction = Vector2.ZERO
