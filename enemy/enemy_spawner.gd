class_name EnemySpawner
extends Marker2D


@export var period_range := Vector2(2.0, 5.0)
@export var timer: Timer
@export var enemies: Array[PackedScene]

const max_enemies := 200


func _ready() -> void:
	timer.timeout.connect(on_timeout)
	start_timer()


func on_timeout() -> void:
	spawn_enemy(enemies.pick_random())
	start_timer()


func start_timer() -> void:
	timer.start(randf_range(period_range.x, period_range.y))
	period_range *= 0.99


func spawn_enemy(scene: PackedScene) -> void:
	if PlayerManager.enemies_active < max_enemies:
		var enemy = scene.instantiate()
		enemy.global_position = global_position
		PlayerManager.mall_inst.add_child(enemy)
		PlayerManager.enemies_active += 1
