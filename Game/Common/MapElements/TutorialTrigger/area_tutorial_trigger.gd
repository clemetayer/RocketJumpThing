extends Collidable
# An area that triggers a tutorial on player entered

# TODO : maybe for hints that are before the checkpoint, free these ? (so if the player goes back, he/she doesn't trigger the tutorial anymore)

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _key: String
var _time: float


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_entered", self, "_on_area_tutotial_trigger_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_area_tutotial_trigger_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)
	if (
		SignalManager.connect(
			"respawn_player_on_last_cp", self, "_on_SignalManager_respawn_player_on_last_cp"
		)
		!= OK
	):
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"respawn_player_on_last_cp",
					"_on_SignalManager_respawn_player_on_last_cp",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	if 'key' in properties:
		self._key = properties.key
	if 'time' in properties:
		self._time = properties.time


##### PROTECTED METHODS #####
# enables or disables collisions 
func _enable_collisions(enabled: bool) -> void:
	for child in get_children():
		if child is CollisionShape or child is CollisionPolygon:
			child.disabled = ! enabled


##### SIGNAL MANAGEMENT #####
func _on_area_tutotial_trigger_body_entered(body):
	if body.is_in_group("player"):
		SignalManager.emit_trigger_tutorial(_key, _time)
		_enable_collisions(false)


func _on_SignalManager_respawn_player_on_last_cp() -> void:
	_enable_collisions(true)
