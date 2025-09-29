class_name DurabilityLabel
extends Label


func _process(_delta: float) -> void:
	text = str(round(PlayerManager.durability * 100.0)) + "%"
	if PlayerManager.durability <= 0.35:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
