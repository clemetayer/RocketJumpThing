extends RichTextLabel
# General appreciation of the performance after the game

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const APPRECTIATION_DICT := {
	300000: TranslationKeys.END_GAME_APPRECIATION_HOW,  # 5 min
	900000: TranslationKeys.END_GAME_APPRECIATION_HOW,  # 15 min
	1800000: TranslationKeys.END_GAME_APPRECIATION_AMAZING,  # 30 min
	3600000: TranslationKeys.END_GAME_APPRECIATION_WELL_DONE,  # 1h
	7200000: TranslationKeys.END_GAME_APPRECIATION_NOT_BAD,  # 2h
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_time_text(RuntimeUtils.get_levels_total_time())


##### PROTECTED METHODS #####
func _set_time_text(time: int):
	set_bbcode(APPRECTIATION_DICT[7200000])  # default bbcode
	for key in APPRECTIATION_DICT.keys():
		if time <= key:
			set_bbcode(tr(APPRECTIATION_DICT[key]))
			return
