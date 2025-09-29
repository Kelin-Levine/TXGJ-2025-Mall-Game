class_name TimeLabel
extends Label


func _process(_delta: float) -> void:
	text = str(PlayerManager.time).pad_decimals(2)
	if PlayerManager.time < 10.0:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
