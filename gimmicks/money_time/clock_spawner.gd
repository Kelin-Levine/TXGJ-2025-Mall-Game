class_name ClockSpawner
extends Marker2D


@export var period_range := Vector2(6.0, 15.0)
@export var spawn_range: Rect2
@export var max_clocks := 3
@export var timer: Timer
@export var clock_scene: PackedScene


func _ready() -> void:
	timer.timeout.connect(on_timeout)
	start_timer()


func on_timeout() -> void:
	if PlayerManager.clocks_active < max_clocks:
		spawn_clock(clock_scene)
	start_timer()


func start_timer() -> void:
	timer.start(randf_range(period_range.x, period_range.y))


func spawn_clock(scene: PackedScene) -> void:
	var clock = scene.instantiate()
	clock.global_position = global_position + spawn_range.position
	clock.global_position += Vector2(randf_range(0, spawn_range.size.x), randf_range(0, spawn_range.size.y))
	PlayerManager.clocks_active += 1
	PlayerManager.mall_inst.add_child(clock)
