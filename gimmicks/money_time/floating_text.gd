class_name FloatingText
extends Label


@export var rise_speed: float = 10.0
@export var timer: Timer


func _ready() -> void:
	timer.timeout.connect(queue_free)


func _process(delta: float) -> void:
	self_modulate = Color(self_modulate, timer.time_left / timer.wait_time)
	position.y += rise_speed * delta
