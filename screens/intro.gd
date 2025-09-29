class_name Intro
extends Control


@export var start_button: Button
@export var title_screen: CanvasLayer
@export var mall: PackedScene
@export var title_music: AudioStreamPlayer
@export var comic_music: AudioStreamPlayer
@export var womp_music: AudioStreamPlayer

var progress := 0
var can_click := false


func _ready() -> void:
	start_button.pressed.connect(start)
	InputManager.get_button(&"fire").just_pressed.connect(on_fire)
	PlayerManager.intro_inst = self


func start() -> void:
	progress = 0
	next(true)
	visible = true
	can_click = true


func next(first: bool) -> void:
	var children := get_children()
	for i in range(len(children)-1):
		children[i+1].visible = i == progress
	if progress == len(children) - 3:
		start_game()
		title_music.stop()
		comic_music.stop()
	if progress == 0 and not first:
		visible = false
		can_click = false
	if progress == 0 and first:
		title_music.stop()
		comic_music.play()
	progress += 1
	progress = progress % (len(children)-1)


func start_game() -> void:
	title_screen.visible = false
	can_click = false
	PlayerManager.money = 500.0
	PlayerManager.time = 60.0
	PlayerManager.durability = 0.0
	PlayerManager.clocks_active = 0
	PlayerManager.enemies_active = 0
	PlayerManager.mall_inst = mall.instantiate()
	get_tree().root.add_child(PlayerManager.mall_inst)


func end_game() -> void:
	PlayerManager.mall_inst.queue_free()
	PlayerManager.mall_inst = null
	title_music.play()
	womp_music.play()
	title_screen.visible = true
	await get_tree().create_timer(1.5).timeout
	can_click = true


func on_fire() -> void:
	if can_click:
		next(false)
