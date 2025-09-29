class_name FreddyFiveNights
extends Enemy2D


func _physics_process(delta: float) -> void:
	if PlayerManager.time > 0.0:
		PlayerManager.mall_inst.kill_freddy_five_nights()
		queue_free()
	else:
		super._physics_process(delta)
		rotation = 0.0


func move_and_slide_and_shove() -> void:
	if move_and_slide():
		var collision := get_last_slide_collision()
		var body := collision.get_collider()
		if body is Player:
			PlayerManager.intro_inst.end_game()
