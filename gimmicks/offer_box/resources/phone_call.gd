class_name PhoneCall
extends BoxCall


@export var audio: AudioStream
@export var item: PackedScene
@export var price: float


func has_item() -> bool:
	return item != null
