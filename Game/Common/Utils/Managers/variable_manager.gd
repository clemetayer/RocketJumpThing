extends Node
# An autoload script to store useful variables at runtime

##### CONSTANTS #####
#---- PLAYER -----
const ABILITY_SLIDE := "slide"
const ABILITY_ROCKETS := "rockets"

#---- INPUTS -----
const INPUT_MVT_FORWARD := "movement_forward"
const INPUT_MVT_BACKWARD := "movement_backward"
const INPUT_MVT_LEFT := "movement_left"
const INPUT_MVT_RIGHT := "movement_right"
const INPUT_MVT_JUMP := "movement_jump"
const INPUT_MVT_SLIDE := "movement_slide"
const INPUT_ACTION_SHOOT := "action_shoot"
const INPUT_RESTART_LAST_CP := "restart_last_cp"
const INPUT_RESTART := "restart"
const INPUT_PAUSE := "pause"

#---- MOUSE BUTTONS TEXTS ----
const MOUSE_LEFT := "left_click"
const MOUSE_RIGHT := "right_click"
const MOUSE_MIDDLE := "middle_click"
const MOUSE_SPECIAL_1 := "mouse_special_1"
const MOUSE_SPECIAL_2 := "mouse_special_2"
const MOUSE_WHEEL_UP := "mouse_wheel_up"
const MOUSE_WHEEL_DOWN := "mouse_wheel_down"
const MOUSE_WHEEL_LEFT := "mouse_wheel_left"
const MOUSE_WHEEL_RIGHT := "mouse_wheel_right"
const MOUSE_MASK_LEFT := "mask_left_click"
const MOUSE_MASK_RIGHT := "mask_right_click"
const MOUSE_MASK_MIDDLE := "mask_middle_click"
const MOUSE_MASK_SPECIAL_1 := "mask_mouse_special_1"
const MOUSE_MASK_SPECIAL_2 := "mask_mouse_special_2"

#---- REPLACE KEYS -----
const TR_REPLACE_PATTERN := "##"
const TR_REPLACE_TUTORIAL_MVT_WASD := "movement_wasd"
const TR_REPLACE_TUTORIAL_MVT_WA := "movement_wa"
const TR_REPLACE_TUTORIAL_MVT_WD := "movement_wd"
const TR_REPLACE_TUTORIAL_MVT_W := "movement_w"
const TR_REPLACE_TUTORIAL_MVT_JUMP := "movement_jump"
const TR_REPLACE_TUTORIAL_MVT_SLIDE := "movement_slide"
const TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT := "mouse_strafe_left"
const TR_REPLACE_TUTORIAL_MOUSE_STRAFE_RIGHT := "mouse_strafe_right"
const TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT_RIGHT := "mouse_strafe_left_right"
const TR_REPLACE_TUTORIAL_RESTART := "restart"
const TR_REPLACE_TUTORIAL_RESTART_LAST_CP := "restart_last_cp"
const TR_REPLACE_TUTORIAL_ACTION_SHOOT := "shoot"
const TR_REPLACE_TUTORIAL_ROCKET_ICON := "rocket_icon"
const TR_REPLACE_TUTORIAL_ROCKET_JUMP_ICON := "rocket_jump_icon"
const TR_REPLACE_TUTORIAL_BOOST_PAD := "boost_pad"
const TR_REPLACE_TUTORIAL_BOOST_PAD_ENHANCED := "boost_pad_enhanced"

#---- AUDIO BUSES -----
const MAIN_BUS := "Master"
const BGM_BUS := "BGM"
const EFFECTS_BUS := "FX"

##### VARIABLES #####
#---- SCENE UTILS -----
var chronometer := {"level": 0}  # chronometer values in milliseconds
var scene_unloading := false  # usefull to avoid making the game crash in some cases where the game is running and unloading at the same time
