tool
extends Spatial
# The big bad spooky entity

##### SIGNALS #####
signal health_updated(health_points)

##### VARIABLES #####
#---- CONSTANTS -----
const SHOCKWAVE_ANIM := "explode"
const APPEAR_ANIM := "appear"
const DISAPPEAR_ANIM := "disappear"
const HURT_ANIM := "hurt"
const DESTROY_ANIM := "destroy"
const MOCK_PLAYER := false  # to mock the position player with an arbitrary position for the tests
const ENTITY_HP := 7  # Entity's health points

#---- STANDARD -----
#==== PRIVATE ====
var _player: KinematicBody
var _hp := ENTITY_HP
var _eye_shakers := [null, null, null]  # wow that's a weird variable name, anyway, those represent the xyz position value nodes that are shaken
var _armor_shakers := [null, null, null]  # kind of the same

#==== ONREADY ====
onready var onready_paths := {
	"eye": $Eye,
	"armor": $Armor,
	"animation_player": $AnimationPlayer,
	"laser": $"Laser",
	"mock_player_pos": $"MockPlayerPos"
}


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if is_instance_valid(_get_player()):
		if onready_paths.laser != null and onready_paths.laser.update_rotation:
			onready_paths.laser.look_at(_get_player().global_transform.origin, Vector3.UP)
			onready_paths.laser.mock_position = _get_player().global_transform.origin
			onready_paths.laser.mock = MOCK_PLAYER
		if onready_paths.eye != null:
			onready_paths.eye.look_at(_get_player().global_transform.origin, Vector3.UP)


##### PUBLIC METHODS #####
# triggers the "hurt" animation
func hurt() -> void:
	onready_paths.animation_player.play(HURT_ANIM)
	if _hp > 0:
		_hp -= 1
		emit_signal("health_updated", _hp)
	Logger.debug("Hp left : %d" % _hp)
	if _hp <= 0:
		Logger.debug("game_done")
		destroy()
		SignalManager.emit_entity_destroyed()


# triggers the shockwave animation
func shockwave() -> void:
	onready_paths.animation_player.play(SHOCKWAVE_ANIM)


# triggers the appear animation
func appear() -> void:
	onready_paths.animation_player.play(APPEAR_ANIM)


# triggers the disappear animation
func disappear() -> void:
	onready_paths.animation_player.play(DISAPPEAR_ANIM)


# makes the entity fire a laser
func fire_laser() -> void:
	if _hp > 0:
		onready_paths.laser.fire()


# destroys the entity
func destroy() -> void:
	onready_paths.animation_player.play(DESTROY_ANIM)


# shakes the meshes to create a hurt/destroy animation
func shake_meshes(duration, frequency, amplitude) -> void:
	_cancel_current_shake()
	# Declares the shake variables
	## for the eye
	var eye_shake_var_x = ShakeVariable.new(onready_paths.eye, "transform:origin:x", 0)
	var eye_shake_var_y = ShakeVariable.new(onready_paths.eye, "transform:origin:y", 0)
	var eye_shake_var_z = ShakeVariable.new(onready_paths.eye, "transform:origin:z", 0)
	## for the armor
	var armor_shake_var_x = ShakeVariable.new(onready_paths.armor, "transform:origin:x", 0)
	var armor_shake_var_y = ShakeVariable.new(onready_paths.armor, "transform:origin:y", 0)
	var armor_shake_var_z = ShakeVariable.new(onready_paths.armor, "transform:origin:z", 0)
	# Declares the shakers
	## for the eye
	_eye_shakers[0] = VariableShaker.new(eye_shake_var_x, amplitude, duration, frequency)
	_eye_shakers[1] = VariableShaker.new(eye_shake_var_y, amplitude, duration, frequency)
	_eye_shakers[2] = VariableShaker.new(eye_shake_var_z, amplitude, duration, frequency)
	## for the armor
	_armor_shakers[0] = VariableShaker.new(armor_shake_var_x, amplitude, duration, frequency)
	_armor_shakers[1] = VariableShaker.new(armor_shake_var_y, amplitude, duration, frequency)
	_armor_shakers[2] = VariableShaker.new(armor_shake_var_z, amplitude, duration, frequency)
	# adds the shakers as child and starts the shake
	for vec_3_idx in range(0, 3):
		add_child(_eye_shakers[vec_3_idx])
		add_child(_armor_shakers[vec_3_idx])
		_eye_shakers[vec_3_idx].start_shake()
		_armor_shakers[vec_3_idx].start_shake()


##### PROTECTED METHODS #####
func _cancel_current_shake() -> void:
	for vec_3_idx in range(0, 3):
		if _eye_shakers.size() > vec_3_idx and is_instance_valid(_eye_shakers[vec_3_idx]):
			_eye_shakers[vec_3_idx].stop_shake()
		if _armor_shakers.size() > vec_3_idx and is_instance_valid(_armor_shakers[vec_3_idx]):
			_armor_shakers[vec_3_idx].stop_shake()


func _get_player() -> KinematicBody:
	if MOCK_PLAYER:
		return onready_paths.mock_player_pos
	if (
		_player == null
		and get_tree() != null
		and get_tree().get_nodes_in_group(GlobalConstants.PLAYER_GROUP).size() > 0
	):
		_player = get_tree().get_nodes_in_group(GlobalConstants.PLAYER_GROUP)[0]
	return _player
