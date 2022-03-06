extends CenterContainer
# A replacement to the "WASD" icon, to adapt to the keys for the player (that can be "ZQSD" on a french keyboard for instance)

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var emphase_keys = {"W": false, "A": false, "S": false, "D": false}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_keys()
	set_emphasis()


##### PUBLIC METHODS ######
func set_emphasis() -> void:
	$WASDHBox/W/Button.pressed = emphase_keys.W
	$WASDHBox/ASD/ASDVBox/A/Button.pressed = emphase_keys.A
	$WASDHBox/ASD/ASDVBox/S/Button.pressed = emphase_keys.S
	$WASDHBox/ASD/ASDVBox/D/Button.pressed = emphase_keys.D


##### PROTECTED METHODS #####
func _set_keys() -> void:
	$WASDHBox/W/Button.set_text(InputMap.get_action_list("movement_forward")[0].as_text())
	$WASDHBox/ASD/ASDVBox/A/Button.set_text(InputMap.get_action_list("movement_left")[0].as_text())
	$WASDHBox/ASD/ASDVBox/S/Button.set_text(
		InputMap.get_action_list("movement_backward")[0].as_text()
	)
	$WASDHBox/ASD/ASDVBox/D/Button.set_text(InputMap.get_action_list("movement_right")[0].as_text())
