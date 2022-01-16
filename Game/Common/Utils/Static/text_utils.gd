extends Reference
class_name TextUtils
# Various static functions for modifying text (BBCode, etc.)

##### PUBLIC METHODS #####
# centers the text with BBCode
static func BBCode_center_text(txt: String) -> String:
	return "[center]%s[/center]" % txt

# colors the text with BBCode
static func BBCode_color_text(txt: String, color: String) -> String:
	return "[color=%s]%s[/color]" % [color, txt]

# creates a wave with BBCode
static func BBCode_wave_text(txt: String, amp: float = 50.0, freq: float = 2.0) -> String:
	return "[wave amp=%f freq=%f]%s[/wave]" % [amp, freq, txt]

# replaces matching elements from the text with whatever is specified in the dictionary
static func replace_elements(text: String, elements: Dictionary) -> String:
	var new_str := text
	for key in elements:
		new_str = new_str.replace(key, elements[key])
	return new_str
