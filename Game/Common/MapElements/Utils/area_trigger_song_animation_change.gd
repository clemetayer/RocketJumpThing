extends Collidable
# Changes the global song animation to the one in parameters on triggered

##### VARIABLES #####
#---- CONSTANTS -----
const TB_AREA_TRIGGER_SONG_ANIMATION_CHANGE_MAPPER := [["animation", "_animation"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _animation: String


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_AREA_TRIGGER_SONG_ANIMATION_CHANGE_MAPPER
	)


# init function to override
func _init_func() -> void:
	._init_func()
	_connect_signals()


func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		var song_instance = StandardSongManager.get_current().duplicate()
		song_instance.ANIMATION = properties.animation
		var effect = FilterEffectManager.new()
		effect.TIME = 1.0
		StandardSongManager.add_to_queue(song_instance, effect)
