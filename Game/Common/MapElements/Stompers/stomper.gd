extends Collidable
class_name Stomper
# A thing that stomps things (especially the player)
# Should be customized to be activated (by using function trigger, step sequencer, etc.)

##### VARIABLES #####
#---- CONSTANTS -----
const TB_STOMPER_MAPPER := [
	["stomp_position", "_stomp_position"],
	["attack", "_attack"],
	["decay", "_decay"],
	["release", "_release"],
	["shake_intensity", "_shake_intensity"],
	["max_shake_distance", "_max_shake_distance"]
]  # mapper for TrenchBroom parameters
const STD_SHAKE_DURATION := 1.0  # standard shake duration for a shake intensity of 1
const SHAKE_FREQUENCY := 20  # standard shake frequency for a shake intensity of 1
const STD_SHAKE_AMPLITUDE := 0.1  # shake amplitude for a shake intensity of 1
const SHAKE_PRIORITY := 1.0  # shake priority

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _signal_name := ""  # signal name to trigger the stomp
var _stomp_position := Vector3.ZERO  # "Stomp" position, relative to self
var _attack := 0.25  # time it takes to reach the stomp position
var _decay := 0.25  # time it takes to stay in stomp position
var _release := 0.5  # time it takes to go back to initial position
var _shake_intensity := 1.0  # intensity of the camera shake on a stomp
var _max_shake_distance := 50.0  # max distance where the player should "feel" the stomps
var _original_position := Vector3.ZERO  # original position of the stomper

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()
	_original_position = self.translation


##### PUBLIC METHODS #####
func stomp() -> void:
	var tween := Tween.new()
	DebugUtils.log_tween_interpolate_property(
		tween,
		self,
		"translation",
		_original_position,
		_original_position + _stomp_position,
		_attack
	)
	add_child(tween)
	DebugUtils.log_tween_start(tween)
	yield(tween, "tween_all_completed")
	# Camera shake
	if ScenesManager.get_current() is StandardScene:
		var distance := global_transform.origin.distance_to(
			ScenesManager.get_current().get_player().global_transform.origin
		)
		if distance <= _max_shake_distance:
			var demultiplier := 1 - (distance / _max_shake_distance)
			CameraUtils.start_camera_shake(
				STD_SHAKE_DURATION,
				SHAKE_FREQUENCY,
				STD_SHAKE_AMPLITUDE * _shake_intensity * demultiplier,
				SHAKE_PRIORITY
			)
	DebugUtils.log_tween_interpolate_property(
		tween,
		self,
		"translation",
		_original_position + _stomp_position,
		_original_position,
		_attack,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		_decay
	)
	DebugUtils.log_tween_start(tween)
	yield(tween, "tween_all_completed")
	tween.queue_free()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_STOMPER_MAPPER)


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		SignalManager.emit_respawn_player_on_last_cp()
