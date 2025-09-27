class_name Player
extends CharacterBody2D


@export var speed: float = 10.0
@export var aim_offset: float = 10.0

var tool: ToolBase = null


func _ready() -> void:
	InputManager.get_button(&"fire").just_pressed.connect(fire_tool)


func _physics_process(_delta: float) -> void:
	velocity = InputManager.get_axis(&"move").value * speed
	move_and_slide()
	
	var aim := InputManager.get_axis(&"aim").value
	tool.position = aim * aim_offset
	tool.rotation = aim.angle()


func fire_tool() -> void:
	if has_tool():
		tool.fire()


func has_tool() -> bool:
	return tool != null


func drop_tool() -> void:
	if has_tool():
		add_sibling(tool)
		tool = null


func give_tool(t: ToolBase) -> void:
	drop_tool()
	add_child(t)
	tool = t
