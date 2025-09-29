class_name BoxMessage
extends Resource


@export var char_duration: int = 50
@export var end_delay: int = 1000
@export var raw_text: String

var text: String


func format(number: String) -> void:
	text = raw_text.replace("\\n", "\n").replace("{num}", number)
