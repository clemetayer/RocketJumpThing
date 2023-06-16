extends Collidable
# A simple area that triggers a signal when the player enters the area

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal trigger

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_COLLIDABLE_MAPPER)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_area_trigger_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_area_trigger_body_entered(body) -> void:
	if FunctionUtils.is_player(body):
		emit_signal("trigger")
