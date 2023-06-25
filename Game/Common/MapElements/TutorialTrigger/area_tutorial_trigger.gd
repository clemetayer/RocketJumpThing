extends Collidable
# An area that triggers a tutorial on player entered

# TODO : maybe for hints that are before the checkpoint, free these ? (so if the player goes back, he/she doesn't trigger the tutorial anymore)

##### VARIABLES #####
#---- CONSTANTS -----
const TB_AREA_TUTORIAL_MAPPER := [["key", "_key"], ["time", "_time"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _key: String
var _time: float


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(self,self,"body_entered", "_on_area_tutorial_trigger_body_entered")
	DebugUtils.log_connect(SignalManager,self,"respawn_player_on_last_cp", "_on_SignalManager_respawn_player_on_last_cp")

func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_AREA_TUTORIAL_MAPPER)


# enables or disables collisions
func _enable_collisions(enabled: bool) -> void:
	for child in get_children():
		if child is CollisionShape or child is CollisionPolygon:
			child.disabled = !enabled


##### SIGNAL MANAGEMENT #####
func _on_area_tutorial_trigger_body_entered(body):
	if FunctionUtils.is_player(body):
		SignalManager.emit_trigger_tutorial(_key, _time)
		_enable_collisions(false)


func _on_SignalManager_respawn_player_on_last_cp() -> void:
	_enable_collisions(true)
