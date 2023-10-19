extends RichTextLabel
# sets the label of the text time

##### VARIABLES #####
#---- EXPORTS -----
export(int) var LEVEL_IDX

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	var time = RuntimeUtils.levels_data.get_level(LEVEL_IDX).LAST_TIME
	var millis = fmod(time, 1000)
	var seconds = floor(fmod(time / 1000, 60))
	var minutes = floor(time / (1000 * 60))
	var time_str = "%02d:%02d:%03d" % [minutes, seconds, millis]
	set_bbcode(tr(TranslationKeys.END_GAME_TEST_X_PASSED) % [LEVEL_IDX, time_str])
