extends RichTextLabel
# Tests results


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_time_bbcode(RuntimeUtils.get_levels_total_time())


##### PROTECTED METHODS #####
func _set_time_bbcode(time: int) -> void:
	var millis = fmod(time, 1000)
	var seconds = floor(fmod(time / 1000, 60))
	var minutes = floor(time / (1000 * 60))
	var time_str = "%02d:%02d:%03d" % [minutes, seconds, millis]
	set_bbcode(tr(TranslationKeys.END_GAME_TESTS_RESULTS) % time_str)
