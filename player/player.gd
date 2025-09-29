class_name Player
extends CharacterBody2D


@export var speed: float = 10.0
@export var tool_handle: Node2D
@export var sprite: Sprite2D
@export var tex_arms_in: Texture2D
@export var tex_arms_out: Texture2D

var tool: ToolBase = null


func _ready() -> void:
	InputManager.get_button(&"fire").just_pressed.connect(fire_tool)
	PlayerManager.inst = self


func _physics_process(_delta: float) -> void:
	var aim := InputManager.get_axis(&"aim").value
	rotation = aim.angle()
	
	velocity = InputManager.get_axis(&"move").value * speed
	move_and_slide()


func hurt(_damage: float, knockback: Vector2) -> void:
	velocity = knockback
	move_and_slide()


func fire_tool() -> void:
	if has_tool():
		tool.fire()
		if PlayerManager.durability <= 0.0:
			drop_tool()


func has_tool() -> bool:
	return tool != null


func drop_tool() -> void:
	if has_tool():
		tool.reparent(get_parent())
		tool.discard()
		tool = null
		sprite.texture = tex_arms_in
		PlayerManager.durability = 0.0


func give_tool(t: ToolBase) -> void:
	drop_tool()
	tool = t
	tool_handle.add_child(tool)
	tool.position = Vector2.ZERO
	tool.rotation = 0.0
	sprite.texture = tex_arms_out
	PlayerManager.durability = 1.0
