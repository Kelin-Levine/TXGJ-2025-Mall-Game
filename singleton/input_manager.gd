extends Node


class button:
	signal just_pressed
	signal pressed_stay
	signal just_released
	
	var is_just_pressed: bool = false
	var is_pressed: bool = false
	var is_just_released: bool = false
	
	var action: StringName
	var override := Callable()
	
	func _init(action_name: StringName):
		action = action_name
	
	func update_value() -> void:
		var now_pressed: bool
		if override.is_valid():
			now_pressed = override.call()
		else:
			now_pressed = Input.is_action_pressed(action)
		
		is_just_pressed = now_pressed and not is_pressed
		is_just_released = is_pressed and not now_pressed
		is_pressed = now_pressed
		if is_just_pressed: just_pressed.emit()
		if is_pressed: pressed_stay.emit()
		if is_just_released: just_released.emit()


class axis_2d:
	signal changed
	
	var value: Vector2 = Vector2.ZERO
	
	var min_sqr: float
	var normalized: bool
	
	var up_action: StringName
	var down_action: StringName
	var left_action: StringName
	var right_action: StringName
	var override := Callable()
	
	func _init(up: StringName, down: StringName, left: StringName, right: StringName,
				is_normalized := false, min_mag := 0.0):
		up_action = up
		down_action = down
		left_action = left
		right_action = right
		
		normalized = is_normalized
		min_sqr = min_mag * min_mag
	
	func update_value() -> void:
		var vec: Vector2
		if override.is_valid():
			vec = override.call()
		else:
			vec = Input.get_vector(left_action, right_action, down_action, up_action)
		var mag_sqr := vec.length_squared()
		if mag_sqr < min_sqr:
			vec = Vector2.ZERO
		if normalized:
			vec = vec.normalized()
		
		if vec.is_equal_approx(value):
			value = vec
		else:
			value = vec
			changed.emit()


enum Timing {PROCESS, PHYSICS}

var buttons: Dictionary = {}
var buttons_phys: Dictionary = {}
var axes: Dictionary = {}
var axes_phys: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# New axes and buttons are registered here.
	# Axes may reverse 'up' and 'down' actions to match 2D space, where y+ is down
	register_axis(Timing.PHYSICS, &"move",
			axis_2d.new(&"move_down", &"move_up", &"move_left", &"move_right", false, 0.1))
	register_axis(Timing.PHYSICS, &"aim",
			axis_2d.new(&"aim_down", &"aim_up", &"aim_left", &"aim_right", false, 0.0))
	register_button(Timing.PHYSICS, &"fire", button.new(&"fire"))
	register_button(Timing.PHYSICS, &"phone_0", button.new(&"phone_0"))
	register_button(Timing.PHYSICS, &"phone_1", button.new(&"phone_1"))
	register_button(Timing.PHYSICS, &"phone_2", button.new(&"phone_2"))
	register_button(Timing.PHYSICS, &"phone_3", button.new(&"phone_3"))
	register_button(Timing.PHYSICS, &"phone_4", button.new(&"phone_4"))
	register_button(Timing.PHYSICS, &"phone_5", button.new(&"phone_5"))
	register_button(Timing.PHYSICS, &"phone_6", button.new(&"phone_6"))
	register_button(Timing.PHYSICS, &"phone_7", button.new(&"phone_7"))
	register_button(Timing.PHYSICS, &"phone_8", button.new(&"phone_8"))
	register_button(Timing.PHYSICS, &"phone_9", button.new(&"phone_9"))
	register_button(Timing.PHYSICS, &"phone_clear", button.new(&"phone_clear"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for btn: button in buttons.values():
		btn.update_value()
	for axis: axis_2d in axes.values():
		axis.update_value()


func _physics_process(_delta: float) -> void:
	for btn: button in buttons_phys.values():
		btn.update_value()
	for axis: axis_2d in axes_phys.values():
		axis.update_value()


func send_action_pressed(action: StringName, pressed: bool, event_index: int = -1) -> void:
	var strength: float = 1.0 if pressed else 0.0
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	ev.strength = strength
	ev.event_index = event_index
	Input.parse_input_event(ev)
	Input.action_press(action, strength)

func send_action_strength(action: StringName, strength: float, event_index: int = -1) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.strength = strength
	ev.event_index = event_index
	Input.parse_input_event(ev)
	Input.action_press(action, strength)


func register_button(timing: Timing, button_name: StringName, buttn: button) -> void:
	match timing:
		Timing.PROCESS:
			buttons[button_name] = buttn
			buttons_phys.erase(button_name)
		Timing.PHYSICS:
			buttons_phys[button_name] = buttn
			buttons.erase(button_name)

## Also disconnects all functions from signals of this button.
## Returns whether the button was originally registered.
func unregister_button(button_name: StringName) -> bool:
	var butt: button = null # lmao
	if buttons.has(button_name):
		butt = buttons[button_name]
		buttons.erase(button_name)
	if buttons_phys.has(button_name):
		butt = buttons_phys[button_name]
		buttons_phys.erase(button_name)
	if butt != null:
		disconnect_all(butt.just_pressed)
		disconnect_all(butt.pressed_stay)
		disconnect_all(butt.just_released)
		return true
	else:
		return false

## Set a button to read values from a Callable instead of Input.
## Pass an empty Callable to clear the override.
## If the function becomes inaccessible, Input will be used instead.
## If the button doesn't exist, nothing happens.
func set_button_override(button_name: StringName, override: Callable) -> void:
	if buttons.has(button_name):
		buttons[button_name].override = override
	if buttons_phys.has(button_name):
		buttons_phys[button_name].override = override

## Use:
## signal just_pressed - emitted when the button has just been pressed
## signal pressed_stay - emitted every frame the button has been pressed
## signal just_released - emitted when the button has just been released
## bool is_just_pressed - true when the button has just been pressed
## bool is_pressed - true while the button is pressed
## bool is_just_released - true when the button has just been released
func get_button(button_name: StringName) -> button:
	if buttons.has(button_name):
		return buttons[button_name]
	if buttons_phys.has(button_name):
		return buttons_phys[button_name]
	return null


func register_axis(timing: Timing, axis_name: StringName, axis: axis_2d) -> void:
	match timing:
		Timing.PROCESS:
			axes[axis_name] = axis
			axes_phys.erase(axis_name)
		Timing.PHYSICS:
			axes_phys[axis_name] = axis
			axes.erase(axis_name)

## Also disconnects all functions from signals of this axis.
## Returns whether the axis was originally registered.
func unregister_axis(axis_name: StringName) -> bool:
	var axis: axis_2d = null
	if axes.has(axis_name):
		axis = axes[axis_name]
		axes.erase(axis_name)
	if axes_phys.has(axis_name):
		axis = axes_phys[axis_name]
		axes_phys.erase(axis_name)
	if axis != null:
		disconnect_all(axis.changed)
		return true
	else:
		return false

## Set an axis to read values from a Callable instead of Input.
## Pass an empty Callable to clear the override.
## If the function becomes inaccessible, Input will be used instead.
## If the axis doesn't exist, nothing happens.
func set_axis_override(axis_name: StringName, override: Callable) -> void:
	if axes.has(axis_name):
		axes[axis_name].override = override
	if axes_phys.has(axis_name):
		axes_phys[axis_name].override = override

## Use:
## signal changed - emitted when the axis changes
## Vector2 value - the value of the axis
func get_axis(axis_name: StringName) -> axis_2d:
	if axes.has(axis_name):
		return axes[axis_name]
	if axes_phys.has(axis_name):
		return axes_phys[axis_name]
	return null


func disconnect_all(sig: Signal) -> void:
	for connection in sig.get_connections():
		sig.disconnect(connection[&"callable"])
