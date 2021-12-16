extends Reference
class_name TextUtils
# Various static functions for modifying text (BBCode, etc.)


##### PUBLIC METHODS #####
# centers the text with BBCode
static func BBCode_center_text(txt: String) -> String:
	return "[center]%s[/center]" % txt


static func BBCode_color_text(txt: String, color: String) -> String:
	return "[color=%s]%s[/color]" % [color, txt]
