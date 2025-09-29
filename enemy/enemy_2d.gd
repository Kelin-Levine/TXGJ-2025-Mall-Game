class_name Enemy2D
extends CharacterBody2D


@export var max_health := 5.0
@export var speed := 50.0
@export var value_range := Vector2(18.0, 42.0)
@export var has_shield := false
@export var shield_node: Node2D
@export var sprites: Array[Sprite2D]
@export var wallet_scene: PackedScene

@onready var health := max_health


func _ready() -> void:
	var num_sprites := len(sprites)
	var vis := randi_range(0, num_sprites-1)
	for i in range(num_sprites):
		sprites[i].visible = i == vis


func _physics_process(_delta: float) -> void:
	var player := PlayerManager.inst
	if player != null:
		var diff := player.global_position - global_position
		rotation = diff.angle()
		velocity = diff.normalized() * speed * 2.0
		move_and_slide_and_shove()


func move_and_slide_and_shove() -> void:
	if move_and_slide():
		var collision := get_last_slide_collision()
		var body := collision.get_collider()
		if body is CharacterBody2D and body.has_method(&"hurt"):
			body.call(&"hurt", 0.0, velocity)


func hurt(damage: float, knockback: Vector2) -> void:
	if has_shield:
		if shield_node:
			shield_node.queue_free()
		has_shield = false
	else:
		health -= damage
	if health <= 0.0:
		create_wallet()
		PlayerManager.enemies_active -= 1
		queue_free()
	else:
		velocity = knockback
		move_and_slide()


func create_wallet() -> void:
	var wallet := wallet_scene.instantiate()
	wallet.value = randf_range(value_range.x, value_range.y)
	wallet.global_position = global_position
	PlayerManager.mall_inst.add_child(wallet)
