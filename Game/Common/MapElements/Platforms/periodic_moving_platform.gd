extends KinematicBody
class_name PeriodicMovingPlatform
# code for a platform that moves periodically between a maximum of 5 points (use Vector3(0,0,0) to use less points)
# Note : the collision safe margin of the colliding entity needs to be rather large (like 1 maybe), so that the platform can go against gravity with a kinematic body on it

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
export(Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _pos_array = []  # array of position to cycle through
var _tween: Tween  # Tween to move the platform
var _step_idx := 0  # index of the position in the array
var _travel_time := 0  # times it takes to go from one point to another
var _wait_time := 0  # time to wait after reaching a point
var _transition_type := Tween.TRANS_LINEAR  # Tween transition type
var _ease := Tween.EASE_IN  # Tween ease
var _desired_pos := false

#==== ONREADY ====
onready var onready_translation := self.translation  # keeps a record of the original position of the platform
onready var onready_desired_pos := self.translation  # desired position for the platform to be (variable modified by tween)


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	# init
	_step_idx = 0
	_tween = Tween.new()
	FunctionUtils.log_connect(_tween, self, "tween_all_completed", "_on_tween_all_completed")
	add_child(_tween)
	_pos_array.append(Vector3(0, 0, 0))
	# importing trenchbroom params
	for i in range(0, 5):
		if properties.has("point%d" % i) and properties["point%d" % i] != Vector3(0, 0, 0):
			_pos_array.append(properties["point%d" % i])
	if properties.has("wait_time"):
		_wait_time = properties["wait_time"]
	if properties.has("travel_time"):
		_travel_time = properties["travel_time"]
	if properties.has("trans_type"):
		_transition_type = properties["trans_type"]
	if properties.has("ease"):
		_ease = properties["ease"]
	# sets the first step
	if _pos_array.size() > 1:
		_set_tween_to_pos_idx(_step_idx)


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	var delta_dist = onready_desired_pos - self.translation
	move_and_slide(delta_dist / delta)


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if "collision_layer" in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if "collision_mask" in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask


#==== Other =====
func _set_tween_to_pos_idx(idx: int) -> void:
	_tween.interpolate_property(
		self,
		"onready_desired_pos",
		onready_desired_pos,
		onready_translation + _pos_array[idx],
		_travel_time,
		_transition_type,
		_ease,
		_wait_time
	)
	_tween.start()


##### SIGNAL MANAGEMENT #####
func _on_tween_all_completed() -> void:
	_step_idx = (_step_idx + 1) % _pos_array.size()
	_set_tween_to_pos_idx(_step_idx)
