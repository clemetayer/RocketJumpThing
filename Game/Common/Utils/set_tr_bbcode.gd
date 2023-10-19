extends RichTextLabel
# A very simple scripts that sets the bbcode of a RichTextLabel with a translation key

##### VARIABLES #####
#---- EXPORTS -----
export(String) var TRANSLATION_KEY

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	set_bbcode(tr(TRANSLATION_KEY))
