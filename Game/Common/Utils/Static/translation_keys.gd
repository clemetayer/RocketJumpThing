extends Reference
class_name TranslationKeys
# Translation keys as constants, and other translation utilities

#================================= MAPPERS =================================
const ACTION_MAPPER := {
	"movement_forward": "MOVEMENT_FORWARD",
	"movement_backward": "MOVEMENT_BACKWARD",
	"movement_left": "MOVEMENT_LEFT",
	"movement_right": "MOVEMENT_RIGHT",
	"movement_jump": "MOVEMENT_JUMP",
	"movement_slide": "MOVEMENT_SLIDE",
	"action_shoot": "ACTION_SHOOT",
	"restart_last_cp": "RESTART_LAST_CP",
	"restart": "MENU_RESTART",
	"pause": "PAUSE",
	"test": "test"  # unused, for test purposes
}

const MOUSE_BUTTON_MAPPER := {
	GlobalConstants.MOUSE_LEFT: "LEFT_CLICK",
	GlobalConstants.MOUSE_RIGHT: "RIGHT_CLICK",
	GlobalConstants.MOUSE_MIDDLE: "MIDDLE_CLICK",
	GlobalConstants.MOUSE_SPECIAL_1: "SPECIAL_1",
	GlobalConstants.MOUSE_SPECIAL_2: "SPECIAL_2",
	GlobalConstants.MOUSE_WHEEL_UP: "WHEEL_UP",
	GlobalConstants.MOUSE_WHEEL_DOWN: "WHEEL_DOWN",
	GlobalConstants.MOUSE_WHEEL_LEFT: "WHEEL_LEFT",
	GlobalConstants.MOUSE_WHEEL_RIGHT: "WHEEL_RIGHT",
	GlobalConstants.MOUSE_MASK_LEFT: "LEFT_CLICK_MASK",
	GlobalConstants.MOUSE_MASK_RIGHT: "RIGHT_CLICK_MASK",
	GlobalConstants.MOUSE_MASK_MIDDLE: "MIDDLE_CLICK_MASK",
	GlobalConstants.MOUSE_MASK_SPECIAL_1: "SPECIAL_1_MASK",
	GlobalConstants.MOUSE_MASK_SPECIAL_2: "SPECIAL_2_MASK",
}

#================================= MENUS =================================
#-------------------------------- COMMON ---------------------------------
const MAIN_MENU := "MAIN_MENU"
const MENU_QUIT := "MENU_QUIT"
const MENU_SETTINGS := "MENU_SETTINGS"
const MENU_RESTART := "MENU_RESTART"
const MENU_RETURN := "MENU_RETURN"

#------------------------------- MAIN MENU -------------------------------
const MENU_PLAY := "MENU_PLAY"

#------------------*---------- LEVEL SELECTION ----------------------------
const MENU_LEVEL_SELECTION := "MENU_LEVEL_SELECTION"

#----------------------------- END LEVEL MENU -----------------------------
const MENU_NEXT_LEVEL := "MENU_NEXT_LEVEL"

#------------------------------- PAUSE MENU -------------------------------
const MENU_RESUME := "MENU_RESUME"

#------------------------------ SETTINGS MENU -----------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GLOBAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const MENU_SETTINGS_TAB_GENERAL := "MENU_SETTINGS_TAB_GENERAL"
const MENU_SETTINGS_TAB_CONTROLS := "MENU_SETTINGS_TAB_CONTROLS"
const MENU_SETTINGS_TAB_AUDIO := "MENU_SETTINGS_TAB_AUDIO"
const MENU_SETTINGS_TAB_VIDEO := "MENU_SETTINGS_TAB_VIDEO"
const MENU_SETTINGS_CHANGE_KEY_POPUP := "MENU_SETTINGS_CHANGE_KEY_POPUP"
const MENU_SETTINGS_ADD_CFG_POPUP_TITLE := "MENU_SETTINGS_ADD_CFG_POPUP_TITLE"
const MENU_SETTINGS_ADD_CFG_POPUP_LABEL := "MENU_SETTINGS_ADD_CFG_POPUP_LABEL"
const MENU_SETTINGS_SAVE_CFG_POPUP_TITLE := "MENU_SETTINGS_SAVE_CFG_POPUP_TITLE"
const MENU_SETTINGS_SAVE_CFG_POPUP_LABEL := "MENU_SETTINGS_SAVE_CFG_POPUP_LABEL"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRESETS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const PRESET_CATEGORY := "PRESET_CATEGORY"
const PRESET_LABEL := "PRESET_LABEL"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GENERAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_GENERAL_LANGUAGE_CATEGORY := "SETTINGS_GENERAL_LANGUAGE_CATEGORY"
const SETTINGS_GENERAL_LANGUAGE_OPTION := "SETTINGS_GENERAL_LANGUAGE_OPTION"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONTROLS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_CONTROLS_MOVEMENT_CATEGORY := "SETTINGS_CONTROLS_MOVEMENT_CATEGORY"
const SETTINGS_CONTROLS_ACTION_CATEGORY := "SETTINGS_CONTROLS_ACTION_CATEGORY"
const SETTINGS_CONTROLS_UI_CATEGORY := "SETTINGS_CONTROLS_UI_CATEGORY"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AUDIO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_AUDIO_MAIN_CATEGORY := "SETTINGS_AUDIO_MAIN_CATEGORY"
const SETTINGS_AUDIO_MAIN_LABEL := "SETTINGS_AUDIO_MAIN_LABEL"
const SETTINGS_AUDIO_BGM_CATEGORY := "SETTINGS_AUDIO_BGM_CATEGORY"
const SETTINGS_AUDIO_BGM_LABEL := "SETTINGS_AUDIO_BGM_LABEL"
const SETTINGS_AUDIO_EFFECTS_CATEGORY := "SETTINGS_AUDIO_EFFECTS_CATEGORY"
const SETTINGS_AUDIO_EFFECTS_LABEL := "SETTINGS_AUDIO_EFFECTS_LABEL"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AUDIO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_VIDEO_DISPLAY_CATEGORY := "SETTINGS_VIDEO_DISPLAY_CATEGORY"
const SETTINGS_VIDEO_DISPLAY_MODE := "SETTINGS_VIDEO_DISPLAY_MODE"
const SETTINGS_VIDEO_FULL_SCREEN := "SETTINGS_VIDEO_FULL_SCREEN"
const SETTINGS_VIDEO_WINDOWED := "SETTINGS_VIDEO_WINDOWED"

#================================ COMMON =================================
#---------------------------------- UI -----------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLAYER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const PLAYER_UI_CHECKPOINT := "PLAYER_UI_CHECKPOINT"
const PLAYER_UI_SPEED := "PLAYER_UI_SPEED"
const PLAYER_MESSAGE_SECURITY_STATUS := "PLAYER_MESSAGE_SECURITY_STATUS"
const PLAYER_MESSAGE_SECURITY_DISABLED := "PLAYER_MESSAGE_SECURITY_DISABLED"
const PLAYER_MESSAGE_ACCESS_TO_ANOMALY_GRANTED := "PLAYER_MESSAGE_ACCESS_TO_ANOMALY_GRANTED"

#=============================== TUTORIALS ===============================
#----------------------------- TUTORIAL SCENES ----------------------------
# Ugly way to do this, but RichTextLabel does not include dynamic/viewport images, so whatever I guess...
# If from Trenchbroom, don't forget to update TrenchBroomEntityUtils
const TUTORIAL_MOVE := "TUTORIAL_MOVE"
const TUTORIAL_JUMP := "TUTORIAL_JUMP"
const TUTORIAL_BHOP := "TUTORIAL_BHOP"
const TUTORIAL_STRAFE := "TUTORIAL_STRAFE"
const TUTORIAL_AIR_CONTROL := "TUTORIAL_AIR_CONTROL"
const TUTORIAL_CHECKPOINT := "TUTORIAL_CHECKPOINT"
const TUTORIAL_SLIDE_1 := "TUTORIAL_SLIDE_1"
const TUTORIAL_SLIDE_2 := "TUTORIAL_SLIDE_2"
const TUTORIAL_WALL_RIDE := "TUTORIAL_WALL_RIDE"
const TUTORIAL_ROCKETS := "TUTORIAL_ROCKETS"
const TUTORIAL_ROCKET_JUMP := "TUTORIAL_ROCKET_JUMP"
const TUTORIAL_ROCKET_WALL_JUMP := "TUTORIAL_ROCKET_WALL_JUMP"
const TUTORIAL_ROCKET_PADS := "TUTORIAL_ROCKET_PADS"
