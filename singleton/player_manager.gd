extends Node

signal timeout

var inst: Player = null
var intro_inst: Intro = null
var mall_inst: Mall = null

var money := 0.0
var time := 60.0
var durability := 0.0
var clocks_active := 0
var enemies_active := 0


func _physics_process(delta: float) -> void:
	if is_ingame():
		var prev_time := time
		time -= delta
		if time < 0.0:
			time = 0.0
			if prev_time > 0.0:
				timeout.emit()


func is_ingame() -> bool:
	return mall_inst != null
