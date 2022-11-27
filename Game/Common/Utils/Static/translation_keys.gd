extends Reference
class_name TranslationKeys
# Translation keys as constants, and other translation utilities

#================================= MAPPERS =================================
const ACTION_MAPPER := {
	"movement_forward": "Forward",
	"movement_backward": "Backward",
	"movement_left": "Left",
	"movement_right": "Right",
	"movement_jump": "Jump",
	"movement_slide": "Slide",
	"action_shoot": "Shoot",
	"restart_last_cp": "Last checkpoint",
	"restart": "Restart",
	"pause": "Pause",
	"test": "test"  # unused, for test purposes
}

const MOUSE_BUTTON_MAPPER := {
	GlobalConstants.MOUSE_LEFT: "Left click",
	GlobalConstants.MOUSE_RIGHT: "Right click",
	GlobalConstants.MOUSE_MIDDLE: "Middle click",
	GlobalConstants.MOUSE_SPECIAL_1: "Mouse special 1",
	GlobalConstants.MOUSE_SPECIAL_2: "Mouse special 2",
	GlobalConstants.MOUSE_WHEEL_UP: "Mouse wheel up",
	GlobalConstants.MOUSE_WHEEL_DOWN: "Mouse wheel down",
	GlobalConstants.MOUSE_WHEEL_LEFT: "Mouse wheel left",
	GlobalConstants.MOUSE_WHEEL_RIGHT: "Mouse wheel right",
	GlobalConstants.MOUSE_MASK_LEFT: "Left click (mask)",
	GlobalConstants.MOUSE_MASK_RIGHT: "Right click (mask)",
	GlobalConstants.MOUSE_MASK_MIDDLE: "Middle click (mask)",
	GlobalConstants.MOUSE_MASK_SPECIAL_1: "Mouse special 1 (mask)",
	GlobalConstants.MOUSE_MASK_SPECIAL_2: "Mouse special 2 (mask)",
}

#================================= MENUS =================================
#-------------------------------- COMMON ---------------------------------
const MAIN_MENU := "Main menu"
const MENU_QUIT := "Quit"
const MENU_OPTIONS := "Settings"
const MENU_RESTART := "Restart"
const MENU_RETURN := "Return"

#------------------------------- MAIN MENU -------------------------------
const MENU_PLAY := "Play"

#----------------------------- END LEVEL MENU -----------------------------
const MENU_NEXT_LEVEL := "Next level"

#------------------------------- PAUSE MENU -------------------------------
const MENU_RESUME := "Resume"

#------------------------------ SETTINGS MENU -----------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GLOBAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const MENU_SETTINGS_TAB_GENERAL := "General"
const MENU_SETTINGS_TAB_CONTROLS := "Controls"
const MENU_SETTINGS_TAB_AUDIO := "Audio"
const MENU_SETTINGS_TAB_VIDEO := "Video"
const MENU_SETTINGS_CHANGE_KEY_POPUP := "Enter a key for action %s :"
const MENU_SETTINGS_ADD_CFG_POPUP_TITLE := "Enter a name"
const MENU_SETTINGS_ADD_CFG_POPUP_LABEL := "Enter a preset name :"
const MENU_SETTINGS_SAVE_CFG_POPUP_TITLE := "Please confirm..."
const MENU_SETTINGS_SAVE_CFG_POPUP_LABEL := "Do you want to overwrite %s ?"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRESETS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const PRESET_CATEGORY := "Presets"
const PRESET_LABEL := "Presets :"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GENERAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_GENERAL_LANGUAGE_CATEGORY := "Language"
const SETTINGS_GENERAL_LANGUAGE_OPTION := "Language :"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONTROLS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_CONTROLS_MOVEMENT_CATEGORY := "Movement"
const SETTINGS_CONTROLS_ACTION_CATEGORY := "Action"
const SETTINGS_CONTROLS_UI_CATEGORY := "UI"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AUDIO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_AUDIO_MAIN_CATEGORY := "Main"
const SETTINGS_AUDIO_MAIN_LABEL := "Main :"
const SETTINGS_AUDIO_BGM_CATEGORY := "BGM"
const SETTINGS_AUDIO_BGM_LABEL := "BGM :"
const SETTINGS_AUDIO_EFFECTS_CATEGORY := "Effects"
const SETTINGS_AUDIO_EFFECTS_LABEL := "Effects :"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AUDIO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const SETTINGS_VIDEO_DISPLAY_CATEGORY := "Display"
const SETTINGS_VIDEO_DISPLAY_MODE := "Mode :"
const SETTINGS_VIDEO_FULL_SCREEN := "Full screen"
const SETTINGS_VIDEO_WINDOWED := "Windowed"

#================================ COMMON =================================
#---------------------------------- UI -----------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLAYER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const PLAYER_UI_CHECKPOINT := "Checkpoint !"
const PLAYER_UI_SPEED := "Speed : %s"

#=============================== TUTORIALS ===============================
#----------------------------- TUTORIAL SCENES ----------------------------
# Ugly way to do this, but RichTextLabel does not include dynamic/viewport images, so whatever I guess...
# If from Trenchbroom, don't forget to update TrenchBroomEntityUtils
const TUTORIAL_MOVE := "##movement_wasd## to move."
const TUTORIAL_JUMP := "##movement_jump## to jump."
const TUTORIAL_BHOP := "Keep ##movement_jump## pressed to accelerate."
const TUTORIAL_STRAFE := "To accelerate even further :\n##movement_wa## + ##mouse_strafe_left##\nor\n##movement_wd## + ##mouse_strafe_right##."
const TUTORIAL_AIR_CONTROL := "##movement_w## + ##mouse_strafe_left_right## mid air to keep the direction."
const TUTORIAL_CHECKPOINT := "##restart_last_cp## to respawn at checkpoint.\n##restart## to restart."
const TUTORIAL_SLIDE_1 := "##movement_slide## to slide."
const TUTORIAL_SLIDE_2 := "##movement_jump## while sliding to boost jump."
const TUTORIAL_WALL_RIDE := "##movement_slide## to wallride\n##movement_jump## in wallride to jump."
const TUTORIAL_ROCKETS := "##shoot## to ##rocket_icon##."
const TUTORIAL_ROCKET_JUMP := "##rocket_icon## at feet to ##rocket_jump_icon##."
const TUTORIAL_ROCKET_WALL_JUMP := "##rocket_jump_icon## on the wall to climb."
const TUTORIAL_ROCKET_PADS := "##rocket_icon## + ##boost_pad## to increase the force."
