extends Node
# kind of like function_utils.gd but for everything that cannot be static


#### Display #####
# returns a string to display a pretty version of the input
func display_input_as_string(input: InputEvent) -> String:
	if input is InputEventKey:
		return input.as_text()
	elif input is InputEventMouseButton:
		match input.button_index:
			BUTTON_LEFT:
				return tr(VariableManager.MOUSE_LEFT)
			BUTTON_RIGHT:
				return tr(VariableManager.MOUSE_RIGHT)
			BUTTON_MIDDLE:
				return tr(VariableManager.MOUSE_MIDDLE)
			BUTTON_XBUTTON1:
				return tr(VariableManager.MOUSE_SPECIAL_1)
			BUTTON_XBUTTON2:
				return tr(VariableManager.MOUSE_SPECIAL_2)
			BUTTON_WHEEL_UP:
				return tr(VariableManager.MOUSE_WHEEL_UP)
			BUTTON_WHEEL_DOWN:
				return tr(VariableManager.MOUSE_WHEEL_DOWN)
			BUTTON_WHEEL_LEFT:
				return tr(VariableManager.MOUSE_WHEEL_LEFT)
			BUTTON_WHEEL_RIGHT:
				return tr(VariableManager.MOUSE_WHEEL_RIGHT)
			BUTTON_MASK_LEFT:
				return tr(VariableManager.MOUSE_MASK_LEFT)
			BUTTON_MASK_RIGHT:
				return tr(VariableManager.MOUSE_MASK_RIGHT)
			BUTTON_MASK_MIDDLE:
				return tr(VariableManager.MOUSE_MASK_MIDDLE)
			BUTTON_MASK_XBUTTON1:
				return tr(VariableManager.MOUSE_MASK_SPECIAL_1)
			BUTTON_MASK_XBUTTON2:
				return tr(VariableManager.MOUSE_MASK_SPECIAL_2)
	elif input is InputEventJoypadButton:
		return Input.get_joy_button_string(input.button_index)
	return ""  # TODO : put a better string for unrecognized inputs ?
