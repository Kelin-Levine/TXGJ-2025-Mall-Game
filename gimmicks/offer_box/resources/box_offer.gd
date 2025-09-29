class_name BoxOffer
extends Resource


@export var intercom: IntercomCall
@export var phone: PhoneCall
# Exports are assigned their true values after init,
# so we must be careful not to touch them during init.
# With a Node, we could avoid this by putting initialization
# code in _ready(), which isn't called until the Node enters
# the scene tree. Unfortunately, Resources aren't Nodes.

var number: String

const enable_10_digits := false


func randomize_number() -> void:
	number = rand_num_str(999) + "-" + rand_num_str(999)
	if enable_10_digits:
		number += "-" + rand_num_str(9999)
	format_messages()


func format_messages() -> void:
	for msg in intercom.messages:
		msg.format(number)
	for msg in phone.messages:
		msg.format(number)


func rand_num_str(most: int) -> String:
	var num := str(randi_range(0, most))
	while len(num) < len(str(most)):
		num = "0" + num
	return num
