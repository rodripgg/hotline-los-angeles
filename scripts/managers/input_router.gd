extends Node

enum ControlScheme {
	KEYBOARD_MOUSE,
	GAMEPAD
}

const DEADZONE := 0.20

func get_move_vector(control_scheme: int, joy_id: int = 0) -> Vector2:
	if control_scheme == ControlScheme.KEYBOARD_MOUSE:
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var v := Vector2(
		Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_Y)
	)

	if v.length() < DEADZONE:
		return Vector2.ZERO

	return v.limit_length(1.0)

func get_aim_vector(owner: Node2D, control_scheme: int, joy_id: int = 0) -> Vector2:
	if control_scheme == ControlScheme.KEYBOARD_MOUSE:
		var mouse_dir := owner.get_global_mouse_position() - owner.global_position
		if mouse_dir.length() <= 0.001:
			return Vector2.ZERO
		return mouse_dir.normalized()

	var stick := Vector2(
		Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_Y)
	)

	if stick.length() < DEADZONE:
		return Vector2.ZERO

	return stick.normalized()

func is_fire_pressed(control_scheme: int, joy_id: int = 0) -> bool:
	if control_scheme == ControlScheme.KEYBOARD_MOUSE:
		return Input.is_action_pressed("fire")

	return Input.is_joy_button_pressed(joy_id, JOY_BUTTON_RIGHT_SHOULDER) \
		or Input.is_joy_button_pressed(joy_id, JOY_BUTTON_A)
		
func is_aim_pressed(control_scheme: int, joy_id: int = 0) -> bool:
	if control_scheme == ControlScheme.KEYBOARD_MOUSE:
		return Input.is_action_pressed("aim")

	return Input.is_joy_button_pressed(joy_id, JOY_BUTTON_LEFT_SHOULDER)
