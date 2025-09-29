class_name OfferBox
extends CanvasLayer


@export var offer_cooldown: Vector2 = Vector2(5.0, 15.0)
@export var offer_timer: Timer
@export var dial_delay: Vector2 = Vector2(0.5, 3.0)
@export var dial_timer: Timer
@export var dial_call: BoxCall
@export var dial_broke: BoxCall
@export var message_label: Label
@export var advertisement_sprite: TextureRect
@export var text_box: Control
@export var phone_sprite: AnimatedSprite2D
@export var intercom_sprite: AnimatedSprite2D
@export var number_speaker: NumberSpeaker
@export var audio_player: AudioStreamPlayer
@export var calling_list: Array[BoxOffer]

const calling_list_path := "res://gimmicks/offer_box/calling_list/"
const default_char_duration := 50
const default_end_delay := 1000

var message: BoxMessage = null
var message_start: int = 0

var cur_call: BoxCall = null
var call_index: int = -1
var intercom_number_spoken := false

var cur_offer: BoxOffer = null


func _ready() -> void:
	# load_calls()
	audio_player.finished.connect(on_audio_finished)
	number_speaker.finished.connect(on_number_reading_finished)
	dial_timer.timeout.connect(on_dial_timer_timeout)
	offer_timer.timeout.connect(on_offer_timer_timeout)
	for msg in dial_call.messages:
		msg.format("")
	for msg in dial_broke.messages:
		msg.format("")


func _process(_delta: float) -> void:
	if cur_call != null:
		step_message()
	else:
		message_label.text = ""


func load_calls() -> void:
	calling_list = []
	for res in ResourceLoader.list_directory(calling_list_path):
		print("Loading BoxOffer at: ", calling_list_path+res)
		var offer = ResourceLoader.load(calling_list_path+res, "BoxOffer")
		calling_list.append(offer)


func start_offer(o: BoxOffer) -> void:
	cur_offer = o
	cur_offer.randomize_number()
	start_call(cur_offer.intercom)


func start_call(c: BoxCall) -> void:
	if cur_call != null:
		end_call()
	cur_call = c
	call_index = -1
	step_call()
	text_box.visible = true
	if cur_call is IntercomCall:
		intercom_sprite.play(&"yapping")
		if cur_call.image != null:
			advertisement_sprite.texture = cur_call.image
			advertisement_sprite.visible = true
		else:
			advertisement_sprite.visible = false
		phone_sprite.visible = false
		intercom_sprite.visible = true
		intercom_number_spoken = false
		play_audio(cur_call.audio1)
	elif cur_call is PhoneCall:
		if phone_sprite.animation != &"open":
			phone_sprite.play(&"open")
		phone_sprite.visible = true
		intercom_sprite.visible = false
		advertisement_sprite.visible = false
		play_audio(cur_call.audio)


func start_message(m: BoxMessage) -> void:
	message = m
	message_start = Time.get_ticks_msec()
	step_message()


func end_offer() -> void:
	if cur_call is PhoneCall and cur_call.has_item():
		if PlayerManager.money >= cur_call.price:
			PlayerManager.money -= cur_call.price
			PlayerManager.inst.give_tool(cur_call.item.instantiate())
		else:
			start_call(dial_broke)
			return
	text_box.visible = false
	advertisement_sprite.visible = false
	intercom_sprite.visible = false
	phone_sprite.visible = true
	if phone_sprite.animation != &"close":
		phone_sprite.play(&"close")
	end_call()
	offer_timer.start(randf_range(offer_cooldown.x, offer_cooldown.y))


func end_call() -> void:
	number_speaker.cancel_speaking()
	audio_player.stop()
	cur_call = null


func step_call() -> void:
	call_index += 1
	if call_index < len(cur_call.messages):
		start_message(cur_call.messages[call_index])
	else:
		end_offer()


func step_message() -> void:
	var time := Time.get_ticks_msec()
	var dur = message_start + message.end_delay + (message.char_duration * len(message.text))
	if time < dur:
		@warning_ignore("integer_division")
		var num_chars := (time - message_start) / message.char_duration
		message_label.text = message.text.substr(0, num_chars)
	else:
		step_call()


func play_audio(stream: AudioStream) -> void:
	if stream != null:
		audio_player.stream = stream;
		audio_player.play()


func on_audio_finished() -> void:
	if cur_call is IntercomCall and not intercom_number_spoken:
		intercom_number_spoken = true
		number_speaker.speak_number(cur_offer.number)


func on_number_reading_finished() -> void:
	if cur_call is IntercomCall:
		play_audio(cur_call.audio2)


## Returns whether the number was accepted (i.e. corresponds to call)
func dial_number(number: String) -> bool:
	if cur_call is not PhoneCall and number == cur_offer.number:
		start_call(dial_call)
		dial_timer.start(randf_range(dial_delay.x, dial_delay.y))
		return true
	return false


func on_dial_timer_timeout() -> void:
	start_call(cur_offer.phone)


func on_offer_timer_timeout() -> void:
	start_offer(calling_list.pick_random())
