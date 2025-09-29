class_name NumberSpeaker
extends Node

signal finished

@export var audio_player: AudioStreamPlayer
@export var number_reads: Array[AudioStream]

var speak_num := ""
var speak_prog := -1


func _ready() -> void:
	audio_player.finished.connect(next_number)


func is_speaking() -> bool:
	return speak_prog >= 0


func speak_number(num: String) -> void:
	speak_num = num
	speak_prog = 0
	next_number()


func next_valid_int(string: String, start: int = 0) -> int:
	var str_len := len(string)
	if start >= str_len:
		return -1
	while not string[start].is_valid_int():
		start += 1
		if start >= str_len:
			return -1
	return start


func next_number() -> void:
	if is_speaking():
		speak_prog = next_valid_int(speak_num, speak_prog)
		if speak_prog != -1:
			var next_num := int(speak_num[speak_prog])
			audio_player.stream = number_reads[next_num]
			audio_player.play()
			speak_prog += 1
		else:
			finished.emit()


func cancel_speaking() -> void:
	speak_prog = -1
