# tool
extends KinematicBody
class_name Player
# Script for the player

"""
- TODO : Use a rigid body instead ? Meh actually, it tends to go through floors, and there is a respawn possibility if you're stuck in a wall
- TODO : Explode the rockets on right click ? charge rocket on right click ?
"""

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
#~~~~ CAMERA ~~~~~
const MIN_FOV := 80  # Min and max fov of the camera that changes depending on the character speed
const MAX_FOV := 100
const FOV_MAX_SPEED := 250  # Speed where the fov is maxed out

#~~~~ SOUNDS ~~~~~
const SOUND_MAX_SPEED := 250  # Treshold for the pitch run sound to be maxed

#~~~~ MOVEMENT ~~~~~
#==== GLOBAL =====
const GRAVITY := -80  # Gravity applied to the player
const JUMP_POWER := 33  # Power applied when jumping
const MAX_SLOPE_ANGLE := PI / 4  # Max slope angle where you stop sliding
const STOP_SPEED := 1.0  # Minimum speed to consider the player "stopped"

#==== AIR =====
const AIR_TARGET_SPEED := 110  # Target acceleration when just pressing forward in the air
const AIR_ACCELERATION := 0.75  # Acceleration in air to get to the AIR_TARGET_SPEED

#==== WALL RIDE =====
const WALL_RIDE_ASCEND_AMOUNT := 10.0  # How much the player ascend during a wall ride
const WALL_RIDE_WALL_DISTANCE := 0.25  # distance from the wall normal, to avoid possibly getting stuck in it on some cases
const WALL_JUMP_BOOST := 75.0  # How much speed is given to the player when jumping while wall riding
const WALL_JUMP_UP_BOOST := 40.0  # The up vector that is added when jumping off a wall
const WALL_JUMP_ANGLE := PI / 4  # Angle from the wall forward vector when wall jumping
const WALL_JUMP_MIX_DIRECTION_TIME := 0.5  # How much time after the jumping from a wall should override the forward movement (to avoid a bug that makes the player sticks to the wall)

#==== GROUND =====
const GROUND_TARGET_SPEED := 50  # Ground target speed
const GROUND_ACCELERATION := 4.5  # Acceleration on the ground
const GROUND_DECCELERATION := 4.5  # Decceleration when on ground
const GROUND_FRICTION := 5.0  # Ground friction
const SLIDE_SPEED_BONUS_JUMP := 50  # Speed added when jumping after a slide
const SLIDE_FRICTION := 0.1  # Friction when sliding on the ground. Equivalent to the movement in air, but with a little friction
const AIR_MOVE_TOWARD := 750  # When pressing forward in the air, how much it should stick to the aim direction

#~~~~~ PROJECTILES ~~~~~
const ROCKET_DELAY := 0.75  # Time before you can shoot another rocket
const ROCKET_START_OFFSET := Vector3(0, 0, 0)  # offest position from the player to throw the rocket
const ROCKET_SCENE_PATH := "res://Game/Common/MovementUtils/Rocket/Rocket.tscn"  # Path to the rocket scene

#---- EXPORTS -----
export(Dictionary) var PATHS = {
	"raycasts": {"root": NodePath("."), "left": NodePath("."), "right": NodePath(".")},
	"camera": NodePath("."),
	"rotation_helper": NodePath("."),
	"UI": NodePath("."),
	"run_sound": NodePath("."),
	"jump_sound": NodePath(".")
}
export(bool) var ROCKETS_ENABLED = true
export(bool) var SLIDE_ENABLED = true
export(Dictionary) var properties setget set_properties

#---- STANDARD -----
#==== PUBLIC ====
var mouse_sensitivity = 0.05  # mouse sensitivity
var states = []  # player current states # OPTIMIZATION : Use a bitmask for states, with an enum and everything
var input_movement_vector = Vector2()  # vector for the movement
var vel := Vector3()  # velocity vector
var dir := Vector3()  # wished direction by the player
var current_speed := 0.0  # current speed of the player
var camera  # camera node
var rotation_helper  # rotation helper node

#==== PRIVATE ====
var _add_velocity_vector_queue := []  # queue to add the vector to the velocity on the next process (used to make external elements interact with the player velocity)
var _override_velocity_vector = null  # vector that should override the player's movement
var _slide := false  # used to buffer a slide when in air
var _RC_wall_direction := 0  # 1 if the raycasts aims for the right wall, -1 if the raycast aims for the left wall, 0 if not aiming for any wall
var _charge_shot_time := 0  # time when the shot key was pressed (as unix timestamp, millis)
var _wall_ride_lock := false  # lock for the wall ride to avoid sticking to the wall when jumping
var _mix_to_direction_amount := 1.0  # when in air and pressing forward, how much the velocity should stick to the direction


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(PATHS.camera)
	rotation_helper = get_node(PATHS.rotation_helper)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Timers/UpdateSpeed.start()
	get_node(PATHS.run_sound).play()


func _process(delta):
	_process_sounds()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(delta):
	# get_node(PATHS.camera).fov = (
	# 	MIN_FOV
	# 	+ (MAX_FOV - MIN_FOV) * ease(min(1, current_speed / FOV_MAX_SPEED), 1.6)
	# )
	# DebugDraw.set_text("fov", get_node(PATHS.camera).fov)
	_set_UI_data()
	_process_collision()
	_process_input(delta)
	_process_movement(delta)
	_process_states()


# when an input is pressed
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -89, 89)
		rotation_helper.rotation_degrees = camera_rot


##### PUBLIC METHODS #####
# Adds some vector to move the player (to be queued)
func add_velocity_vector(vector: Vector3) -> void:
	_add_velocity_vector_queue.append(vector)


func override_velocity_vector(vector: Vector3) -> void:
	_override_velocity_vector = vector


# toggles a player ability
func toggle_ability(name: String, enabled: bool) -> void:
	match name:
		"sliding":
			SLIDE_ENABLED = enabled
		"rockets":
			ROCKETS_ENABLED = enabled


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if "angle" in properties:
		rotation_degrees.y = properties.angle


#==== Others =====
#---- UI data -----
# sets the UI infos
func _set_UI_data() -> void:
	var ui := get_node(PATHS.UI)
	ui.set_speed(current_speed)


#---- Process collision -----
# Enables/disables some collisions depending on the states
func _process_collision():
	$PlayerCollision.disabled = states.has("sliding")
	$SlideCollision.disabled = not states.has("sliding")


#---- Process states -----
# Input management
func _process_input(_delta):
	# Camera
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	# Standard movement
	input_movement_vector = Vector2()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()

	# Wished direction
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# Shooting
	if Input.is_action_pressed("action_shoot") and not states.has("shooting") and ROCKETS_ENABLED:
		_shoot(cam_xform)

	# Slide
	if Input.is_action_just_pressed("movement_slide") and SLIDE_ENABLED:
		_slide = true
	elif Input.is_action_just_released("movement_slide"):
		_slide = false


# Shoots a rocket
func _shoot(cam_xform: Transform) -> void:
	states.append("shooting")
	var rocket = load(ROCKET_SCENE_PATH).instance()
	rocket.START_POS = transform.origin + transform.basis * ROCKET_START_OFFSET
	rocket.DIRECTION = -cam_xform.basis.z
	rocket.UP_VECTOR = Vector3(0, 1, 0)
	get_parent().add_child(rocket)
	var _err = get_tree().create_timer(ROCKET_DELAY).connect(
		"timeout", self, "remove_shooting_state"
	)


#---- Process sounds -----
func _process_sounds() -> void:
	if (current_speed / SOUND_MAX_SPEED) * 4.0 > 0.0:
		if !get_node(PATHS.run_sound).playing:
			get_node(PATHS.run_sound).play()
		get_node(PATHS.run_sound).pitch_scale = (current_speed / SOUND_MAX_SPEED) * 4.0
	elif get_node(PATHS.run_sound).playing:
		get_node(PATHS.run_sound).stop()


#---- Process movement -----
# process for the movement
func _process_movement(delta):
	# _debug_process_movement(delta)

	# Wall ride wall check
	if _RC_wall_direction == 0:  # First contact with wall
		_find_wall_direction()

	# Movement process
	if not is_on_floor() and _slide and _RC_wall_direction != 0 and !_wall_ride_lock:
		_wall_ride_movement(delta)
	else:
		_reset_wallride_raycasts()
		if is_on_floor():
			_ground_movement(delta)
		else:
			_air_movement(delta)
	_add_movement_queue_to_vel()
	if _override_velocity_vector != null:
		vel = _override_velocity_vector
		_override_velocity_vector = null

	# Move and slide + update speed
	var snap = Vector3.ZERO if Input.is_action_pressed("movement_jump") else -get_floor_normal()
	vel = move_and_slide_with_snap(vel, snap, Vector3.UP, true, 4, MAX_SLOPE_ANGLE, false)
	current_speed = vel.length()


func _find_wall_direction() -> void:
	if get_node(PATHS.raycasts.right).is_colliding():
		_RC_wall_direction = -1
	elif get_node(PATHS.raycasts.left).is_colliding():
		_RC_wall_direction = 1


# wall ride movement management
func _wall_ride_movement(delta: float) -> void:
	var rc: RayCast = _find_raycast_from_direction(_RC_wall_direction)
	if rc != null and rc.is_colliding():  # if on an "acceptable" wall
		if !states.has("wall_riding"):  # first contact with the wall, snap the player to it
			_init_wall_riding(rc)
		var wall_fw = _get_wall_fw_vector(rc)
		if Input.is_action_pressed("movement_jump"):
			_wall_jump(wall_fw)
		else:
			_wall_ride(rc, wall_fw, delta)
	else:  # resets the wall ride direction
		_RC_wall_direction = 0


# returns the raycast associated with the last raycast direction (_RC_wall_direction)
func _find_raycast_from_direction(direction: int):
	match direction:
		1:
			return get_node_or_null(PATHS.raycasts.left)
		-1:
			return get_node_or_null(PATHS.raycasts.right)
		_:
			return null


# initializes wall riding variables
func _init_wall_riding(rc: RayCast) -> void:
	transform.origin = (
		rc.get_collision_point()
		+ rc.get_collision_normal() * WALL_RIDE_WALL_DISTANCE
	)  # keep a small distance from the wall to avoid getting stuck in it
	states.append("wall_riding")


# returns the vector aligned with the wall, to a forward direction of the player
func _get_wall_fw_vector(rc: RayCast) -> Vector3:
	var wall_normal = rc.get_collision_normal().normalized()  # normal of the wall, should be the aligned with the player x axis
	return (wall_normal.cross(Vector3.UP) * -_RC_wall_direction).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)


# wall jump
func _wall_jump(wall_fw: Vector3) -> void:
	if states.has("wall_riding"):
		_init_wall_ride_lock()
	vel += (wall_fw.rotated(Vector3.UP, WALL_JUMP_ANGLE * -_RC_wall_direction) * WALL_JUMP_BOOST)
	vel += Vector3.UP * WALL_JUMP_UP_BOOST
	get_node(PATHS.jump_sound).play()


func _wall_ride(rc: RayCast, wall_fw: Vector3, delta: float) -> void:
	_keep_wallride_raycasts_perpendicular(rc)
	if not states.has("wall_riding"):
		states.append("wall_riding")
	var vel_dir = Vector3(wall_fw.x, WALL_RIDE_ASCEND_AMOUNT * delta, wall_fw.z).normalized()
	vel = vel_dir * vel.length()


func _init_wall_ride_lock() -> void:
	states.remove("wall_riding")
	$Timers/WallRideJumpLock.start()  # to avoid sticking and accelerating back on the wall after jumping
	_wall_ride_lock = true
	if Input.is_action_pressed("movement_forward"):  # FIXME : probably creates a bug that can make the player wall jump easily to the same wall (but that might make a cool mechanic)
		var tween = get_node("WallJumpMixMovement")
		if tween.is_active():
			tween.stop_all()
		tween.interpolate_property(
			self,
			"_mix_to_direction_amount",
			0.0,
			1.0,
			WALL_JUMP_MIX_DIRECTION_TIME,
			Tween.TRANS_QUART,
			Tween.EASE_IN
		)
		tween.start()


# sets the wallride raycast rotations to stay perpendicular to the wall it is colliding with
func _keep_wallride_raycasts_perpendicular(rc: RayCast) -> void:
	var wall_normal_vect: Vector3  # normal of the wall returned by the raycast
	var raycast_dir_vect: Vector3  # direction to the raycast from the collision point
	var angle: float  # angle between wall_normal_vect and raycast_dir_vect
	wall_normal_vect = rc.get_collision_normal()
	raycast_dir_vect = rc.global_transform.origin - rc.get_collision_point()
	angle = wall_normal_vect.signed_angle_to(raycast_dir_vect, Vector3.UP)
	get_node(PATHS.raycasts.root).rotate_y(-angle)


# resets the wallride raycasts to their standard rotation value
func _reset_wallride_raycasts() -> void:
	$RayCasts.rotation = Vector3(0, 0, 0)


# movement management when on the ground
func _ground_movement(delta: float) -> void:
	_apply_friction(delta)
	_accelerate(
		Vector3(dir.x, 0, dir.z).normalized(), GROUND_TARGET_SPEED, GROUND_ACCELERATION, delta
	)
	if Input.is_action_pressed("movement_jump"):
		vel.y += JUMP_POWER
		if states.has("sliding"):
			_slide_jump()
		get_node(PATHS.jump_sound).play()


# applies friction, mostly for when on floor
func _apply_friction(delta: float):
	var drop := 0.0
	if current_speed <= STOP_SPEED:
		vel.x = 0
		vel.z = 0
		return  # no need to compute things further, the player is stopped
	var control := 0.0
	if is_on_floor() && !Input.is_action_pressed("movement_jump"):
		var friction := SLIDE_FRICTION if _slide else GROUND_FRICTION
		control = GROUND_DECCELERATION if current_speed < GROUND_DECCELERATION else current_speed
		drop += control * friction * delta
	var speed_multiplier := 1.0  # more like a "de"multiplier in most cases
	if current_speed > 0:
		speed_multiplier = abs(current_speed - drop) / current_speed
	vel.x *= speed_multiplier
	vel.z *= speed_multiplier


# accelerates the player, enables strafing
func _accelerate(wish_dir: Vector3, wish_speed: float, accel: float, delta: float):
	var project_speed = vel.dot(wish_dir)  # dot product between the velocity and the wishdir. equivalent of currentspeed in Quake III code, which is the speed on the wishdir (and not the "real" speed vel.length()), but allows air strafing, which is very cool
	var add_speed = wish_speed - project_speed
	if add_speed > 0:  # accelerate only if needed
		var accel_amount := clamp(accel * delta * wish_speed, 0.0, add_speed)  # acceleration amount
		vel.x += accel_amount * wish_dir.x
		vel.z += accel_amount * wish_dir.z


# Executed when jumping while sliding
func _slide_jump():
	vel += Vector3(vel.x, 0, vel.z).normalized() * SLIDE_SPEED_BONUS_JUMP
	_slide = false
	self.rotate_object_local(Vector3(1, 0, 0), PI / 4)
	rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
	states.erase("sliding")


# movement management when in the air
func _air_movement(delta: float) -> void:
	var wish_dir := Vector3(dir.x, 0, dir.z).normalized()
	if input_movement_vector.x == 0 && input_movement_vector.y == 1:  # pressing forward only, forces the velocity direction to the wishdir
		if current_speed < AIR_TARGET_SPEED:  # accelerate if not reached the target speed yet
			_accelerate(wish_dir, AIR_TARGET_SPEED, AIR_ACCELERATION, delta)
		var linear_speed := Vector3(vel.x, 0, vel.z).length()  # keep the current speed
		var direction_vec := wish_dir * linear_speed  # direction and speed of the velocity on a linear axis
		direction_vec.y = vel.y
		vel = vel.move_toward(direction_vec, delta * _mix_to_direction_amount * AIR_MOVE_TOWARD)
	else:  # accelerate and strafe
		_accelerate(wish_dir, AIR_TARGET_SPEED, AIR_ACCELERATION, delta)
	vel.y += GRAVITY * delta


# adds the vectors stored in the _add_velocity_vector_queue to velocity
func _add_movement_queue_to_vel():
	for vect in _add_velocity_vector_queue:
		vel += vect
	_add_velocity_vector_queue = []


#---- Process states -----
# updates the states
func _process_states():
	if _slide:
		if not states.has("sliding") and is_on_floor():
			self.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
			rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
			states.append("sliding")
	if not is_on_floor() and not states.has("in_air"):
		states.append("in_air")
	elif is_on_floor() and states.has("in_air"):
		vel -= get_floor_velocity()  # HACK : to avoid adding speed by just jumping on a moving platform. probably some scenarios where this won't be ideal
		states.erase("in_air")
	if current_speed != 0 and not states.has("moving"):
		states.append("moving")
	if states.has("sliding") and (not Input.is_action_pressed("movement_slide")):
		self.rotate_object_local(Vector3(1, 0, 0), PI / 4)
		rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
		states.erase("sliding")
	if (
		states.has("wall_riding")
		and (
			not Input.is_action_pressed("movement_slide")
			or is_on_floor()
			or _RC_wall_direction == 0
		)
	):
		states.erase("wall_riding")


##### SIGNAL MANAGEMENT #####
func remove_shooting_state():
	if states.has("shooting"):
		states.erase("shooting")


func _on_UpdateSpeed_timeout():
	SignalManager.emit_speed_updated(current_speed)


func _on_WallRideJumpLock_timeout():
	_wall_ride_lock = false


#### DEBUG #####
func _debug_process_movement(_delta: float):
	var rc: RayCast
	var rc_dir := 0
	if $RayCasts/RayCastWallMinus.is_colliding():
		rc = $RayCasts/RayCastWallMinus
		rc_dir = -1
	elif $RayCasts/RayCastWallPlus.is_colliding():
		rc = $RayCasts/RayCastWallPlus
		rc_dir = 1
	if rc != null:
		var wall_normal = rc.get_collision_normal().normalized()  # normal of the wall, should be the aligned with the player x axis
		var wall_up = Vector3(0, 1, 0)  # Up direction from the wall (always that direction)
		var _wall_fw = (wall_normal.cross(wall_up) * -rc_dir).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)
		# Note : wall_normal, wall_up, wall_fw should give a (kind of) orthogonal basis
		# DebugDraw.set_text("Wall direction : ", _RC_wall_direction)
		# DebugDraw.set_text("is colliding : ", rc.is_colliding())
		# DebugDraw.draw_line_3d(
		# 	rc.get_collision_point(), rc.get_collision_point() + wall_normal, Color(1, 0, 0)
		# )
		# DebugDraw.set_text("wall normal", wall_normal)
		# DebugDraw.draw_line_3d(
		# 	rc.get_collision_point(), rc.get_collision_point() + wall_up, Color(0, 1, 0)
		# )
		# DebugDraw.set_text("wall up", wall_up)
		# DebugDraw.draw_line_3d(
		# 	rc.get_collision_point(), rc.get_collision_point() + wall_fw, Color(0, 0, 1)
		# )
		# DebugDraw.set_text("wall fw", wall_fw)
