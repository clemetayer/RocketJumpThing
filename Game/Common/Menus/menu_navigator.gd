extends CanvasLayer
# A navigator for the menus

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal menu_activated(menu)

##### ENUMS #####
enum MENU { hidden, main, pause, settings, level_select, end_level, initial_settings }

##### VARIABLES #####
#---- CONSTANTS -----
const MENU_ACTIVATED_SIGNAL_NAME := "menu_activated"
const TRANSITION_TIME := 0.5

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _menu_stack := [] # used to store the menu states stack
var _state : int = MENU.hidden # current state of the navigator
var _pause_enabled := false # if the pause menu can be shown

#==== ONREADY ====
onready var onready_paths := {
	"background": $"DarkLayer/ColorRect",
	"main":$"MainMenu/MainMenu",
	"pause":$"PauseMenu/PauseMenu",
	"settings":$"SettingsMenu/SettingsMenu",
	"level_select":$"LevelSelectMenu/LevelSelectMenu",
	"end_level": $"EndLevelMenu/EndLevelMenu",
	"transition_tween": $"ToggleMenuTransition",
	"forbidden_menu": $"TheForbiddenMenu",
	"initial_settings": $"SimpleSettingsMenu/DefaultSettings",
	"mouse_click_lock": $"MouseClickLock/MouseClickLock"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_visible()
	_connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_manage_inputs()

##### PUBLIC METHODS #####
# opens the navigation at the specified menu
func open_navigation(start_menu : int) -> void:
	emit_signal(MENU_ACTIVATED_SIGNAL_NAME,start_menu)
	visible = true
	_get_menu_by_id(start_menu).modulate.a = 0
	_get_menu_by_id(start_menu).visible = true
	onready_paths.background.modulate.a = 0
	onready_paths.background.visible = true
	_interpolate_menu_transition_tween(onready_paths.background,1)
	_interpolate_menu_transition_tween(_get_menu_by_id(start_menu),1)
	_disable_clicks()
	DebugUtils.log_tween_start(onready_paths.transition_tween)
	yield(onready_paths.transition_tween,"tween_all_completed")
	_enable_clicks()
	_state = start_menu
	_menu_stack = [start_menu]

# pretty much hides the menus and clears the menu_stack
func exit_navigation() -> void:
	emit_signal(MENU_ACTIVATED_SIGNAL_NAME,MENU.hidden)
	_interpolate_menu_transition_tween(onready_paths.background,0)
	_interpolate_menu_transition_tween(_get_current_menu(),0)
	_disable_clicks()
	DebugUtils.log_tween_start(onready_paths.transition_tween)
	_get_current_menu().visible = false
	yield(onready_paths.transition_tween,"tween_all_completed")
	_enable_clicks()
	_menu_stack = []
	_state = MENU.hidden
	visible = false
	if ScenesManager.paused:
		ScenesManager.unpause(Input.MOUSE_MODE_CAPTURED)

# toggles the pause menu enable
func toggle_pause_enabled(value : bool) -> void:
	_pause_enabled = value

# shows the pause menu
func show_pause_menu() -> void:
	if _pause_enabled and _state == MENU.hidden:
		ScenesManager.pause()
		open_navigation(MENU.pause)

# shows the initial settings menu
func show_initial_settings_menu() -> void:
	open_navigation(MENU.initial_settings)
	_get_menu_by_id(MENU.initial_settings).play_intro_anim()

# shows the main menu
func show_main_menu() -> void:
	open_navigation(MENU.main)

# goes to the previous menu if it exists
func previous_menu() -> void:
	_unstack_menu()

##### PROTECTED METHODS #####
func _init_visible() -> void:
	self.visible = false
	_state = MENU.hidden

func _connect_signals() -> void:
	# Main menu
	DebugUtils.log_connect(onready_paths.main,self,"level_select_requested","_on_MainMenu_LevelSelectRequested")
	DebugUtils.log_connect(onready_paths.main,self,"settings_requested","_on_SettingsRequested")
	# Pause menu
	DebugUtils.log_connect(onready_paths.pause,self,"settings_requested","_on_SettingsRequested")
	# Level select
	DebugUtils.log_connect(onready_paths.level_select,self,"return_to_prev_menu","_on_return")
	# Settings
	DebugUtils.log_connect(onready_paths.settings,self,"return_to_prev_menu","_on_return")

func _manage_inputs() -> void:
	if Input.is_action_just_pressed("pause") and _pause_enabled and not MENU.pause in _menu_stack:
		ScenesManager.pause()
		open_navigation(MENU.pause)
	if Input.is_action_just_pressed("ui_cancel") and not _is_protected_menu(_state):
		if _state == MENU.settings:
			SettingsUtils.save_current_settings()
			SignalManager.emit_update_settings()
		previous_menu()

func _stack_menu(menu : int) -> void:
	Logger.debug("stacking %d, menu stack = %s" % [menu,_menu_stack])
	emit_signal(MENU_ACTIVATED_SIGNAL_NAME,menu)
	_interpolate_menu_transition_tween(_get_current_menu(),0)
	_disable_clicks()
	DebugUtils.log_tween_start(onready_paths.transition_tween)
	yield(onready_paths.transition_tween,"tween_all_completed")
	_get_current_menu().visible = false
	_get_menu_by_id(menu).modulate.a = 0
	_get_menu_by_id(menu).visible = true
	_interpolate_menu_transition_tween(_get_menu_by_id(menu),1)
	DebugUtils.log_tween_start(onready_paths.transition_tween)
	yield(onready_paths.transition_tween,"tween_all_completed")
	_enable_clicks()
	_state = menu
	_menu_stack.push_back(menu)



func _unstack_menu() -> void:
	Logger.debug("unstacking, menu stack = %s" % [_menu_stack])
	if _menu_stack.size() > 0:
		_menu_stack.pop_back()
		var prev_menu = _menu_stack.back()
		if prev_menu != null:
			_interpolate_menu_transition_tween(_get_current_menu(),0)
			_disable_clicks()
			DebugUtils.log_tween_start(onready_paths.transition_tween)
			yield(onready_paths.transition_tween,"tween_all_completed")
			_get_current_menu().visible = false
			emit_signal(MENU_ACTIVATED_SIGNAL_NAME,prev_menu)
			_get_menu_by_id(prev_menu).modulate.a = 0
			_get_menu_by_id(prev_menu).visible = true
			_interpolate_menu_transition_tween(_get_menu_by_id(prev_menu),1)
			DebugUtils.log_tween_start(onready_paths.transition_tween)
			yield(onready_paths.transition_tween,"tween_all_completed")
			_enable_clicks()
			_state = prev_menu
		else:
			exit_navigation()
	else:
		DebugUtils.log_stacktrace("Can't unstack an empty menu stack", DebugUtils.LOG_LEVEL.warn)

func _get_menu_by_id(id : int) -> CanvasItem:
	match id:
		MENU.main:
			return onready_paths.main
		MENU.pause:
			return onready_paths.pause
		MENU.settings:
			return onready_paths.settings
		MENU.level_select:
			return onready_paths.level_select
		MENU.end_level:
			return onready_paths.end_level
		MENU.initial_settings:
			return onready_paths.initial_settings
	DebugUtils.log_stacktrace("Unable to get the menu %d" % id,  DebugUtils.LOG_LEVEL.warn)
	return onready_paths.forbidden_menu

func _get_current_menu() -> CanvasItem:
	return _get_menu_by_id(_state)

# final value is 0 for show -> hide, 1 for hide -> show
func _interpolate_menu_transition_tween(node : CanvasItem, final_val : int) -> void:
	DebugUtils.log_tween_interpolate_property(
		onready_paths.transition_tween,
		node,
		"modulate:a",
		node.modulate.a,
		final_val,
		TRANSITION_TIME / (1.0 / Engine.time_scale)  # HACK : when using a slowmotion effect, to avoid having the animation be slowed down too
	)

func _is_protected_menu(state : int) -> bool:
	return state == MENU.hidden or state == MENU.main

func _enable_clicks() -> void:
	onready_paths.mouse_click_lock.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _disable_clicks() -> void:
	onready_paths.mouse_click_lock.mouse_filter = Control.MOUSE_FILTER_STOP

##### SIGNAL MANAGEMENT #####
func _on_MainMenu_LevelSelectRequested() -> void:
	_stack_menu(MENU.level_select)

func _on_SettingsRequested() -> void:
	_stack_menu(MENU.settings)

func _on_return() -> void:
	_unstack_menu()
