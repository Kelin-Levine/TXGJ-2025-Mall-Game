class_name DialBox
extends Label


@export var offer_box: OfferBox

var cur_num := ""
var cur_num_dashed := ""


func _ready() -> void:
	InputManager.get_button(&"phone_0").just_pressed.connect(on_phone_0)
	InputManager.get_button(&"phone_1").just_pressed.connect(on_phone_1)
	InputManager.get_button(&"phone_2").just_pressed.connect(on_phone_2)
	InputManager.get_button(&"phone_3").just_pressed.connect(on_phone_3)
	InputManager.get_button(&"phone_4").just_pressed.connect(on_phone_4)
	InputManager.get_button(&"phone_5").just_pressed.connect(on_phone_5)
	InputManager.get_button(&"phone_6").just_pressed.connect(on_phone_6)
	InputManager.get_button(&"phone_7").just_pressed.connect(on_phone_7)
	InputManager.get_button(&"phone_8").just_pressed.connect(on_phone_8)
	InputManager.get_button(&"phone_9").just_pressed.connect(on_phone_9)
	InputManager.get_button(&"phone_clear").just_pressed.connect(clear_dial)
	hidden.connect(clear_dial)


func dial_number(number: String) -> void:
	if is_visible_in_tree():
		cur_num += number
		cur_num_dashed = dashify_string(cur_num)
		text = cur_num_dashed
		var accepted := offer_box.dial_number(cur_num_dashed)
		if accepted or len(cur_num) >= 6:
			reset_dial()


func reset_dial() -> void:
	cur_num = ""


func clear_dial() -> void:
	reset_dial()
	text = "_"


func dashify_string(string: String, dash_every: int = 3) -> String:
	var dashified := string.substr(0, min(dash_every, len(string)))
	for i in range(1, ceili(len(string) / float(dash_every))):
		dashified += "-" + string.substr(i*dash_every, dash_every)
	return dashified


# jumpscare warning
func on_phone_0() -> void:
	dial_number("0")
func on_phone_1() -> void:
	dial_number("1")
func on_phone_2() -> void:
	dial_number("2")
func on_phone_3() -> void:
	dial_number("3")
func on_phone_4() -> void:
	dial_number("4")
func on_phone_5() -> void:
	dial_number("5")
func on_phone_6() -> void:
	dial_number("6")
func on_phone_7() -> void:
	dial_number("7")
func on_phone_8() -> void:
	dial_number("8")
func on_phone_9() -> void:
	dial_number("9")
