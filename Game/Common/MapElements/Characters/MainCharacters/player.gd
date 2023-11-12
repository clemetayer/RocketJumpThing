extends KinematicBody
# Script for the player

"""
- TODO : Use a rigid body instead ? Meh actually, it tends to go through floors, and there is a respawn possibility if you're stuck in a wall
- TODO : Explode the rockets on right click ? charge rocket on right click ?
	- Do this in the player subclasses if needed (or add resources to the player to make a 'custom' version)
"""
##### ENUMS #####
enum states_idx {
	MOVING,
	WALL_RIDING,
	SLIDING,
	IN_AIR,
	SHOOTING
}  # states of the player as bitmap indexes

##### VARIABLES #####
#---- CONSTANTS -----
#~~~~ VISUALS ~~~~~
const TRAIL_GRADIENT_SHADER_PARAM := "gradient"

#~~~~ STATES ~~~~~
const STATES_SIZE := 5  # How many states the player has

#~~~~ CAMERA ~~~~~
const MIN_FOV := 80  # Min and max fov of the camera that changes depending on the character speed
const MAX_FOV := 100
const FOV_MAX_SPEED := 16  # Speed where the fov is maxed out

#~~~~ SOUNDS ~~~~~
const SOUND_MAX_SPEED := 16  # Treshold for the pitch run sound to be maxed

#~~~~ MOVEMENT ~~~~~
#==== GLOBAL =====
const GRAVITY := -7  # Gravity applied to the player
const JUMP_POWER := -GRAVITY / 2.15  # Power applied when jumping
const MAX_SLOPE_ANGLE := PI / 4  # Max slope angle where you stop sliding
const STOP_SPEED := 1.0  # Minimum speed to consider the player "stopped"

#==== AIR =====
const AIR_TARGET_SPEED := 8.5  # Target acceleration when just pressing forward in the air
const AIR_ACCELERATION := 0.75  # Acceleration in air to get to the AIR_TARGET_SPEED
const AIR_NO_INPUT_DECELERATION := 0.98 # Deceleration mid air when not pressing anything

#==== WALL RIDE =====
const WALL_RIDE_ASCEND_AMOUNT := 8.0  # How much the player ascend during a wall ride
const WALL_RIDE_WALL_DISTANCE := 0.03  # distance from the wall normal, to avoid possibly getting stuck in it on some cases
const WALL_RIDE_TILT_ANGLE := PI/10.0 # Camera tilt angle during a wall ride 
const WALL_RIDE_TILT_SPEED := 0.075 # speed to tilt the camera when wall riding (in seconds)
const WALL_JUMP_BOOST := AIR_TARGET_SPEED * 1.0 / 3.0  # How much speed is given to the player when jumping while wall riding
const WALL_JUMP_UP_BOOST := JUMP_POWER * 1.5  # The up vector that is added when jumping off a wall
const WALL_JUMP_ANGLE := PI / 4  # Angle from the wall forward vector when wall jumping
const WALL_JUMP_MIX_DIRECTION_TIME := 0.5  # How much time after the jumping from a wall should override the forward movement (to avoid a bug that makes the player sticks to the wall)

#==== GROUND =====
const GROUND_TARGET_SPEED := AIR_TARGET_SPEED * 2.0 / 3.0  # Ground target speed
const GROUND_ACCELERATION := 11  # Acceleration on the ground. For some reason, should be > 10 to counter the friction
const GROUND_FRICTION := 5.0  # Ground friction
const SLIDE_SPEED_BONUS_JUMP := AIR_TARGET_SPEED * 1.0 / 3.0  # Speed added when jumping after a slide
const SLIDE_JUMP_SPEED_CAP := 2.5 * GROUND_TARGET_SPEED # Speed cap for the slide jump
const SLIDE_JUMP_SPEED_CAP_EASE := 0.6 # see https://raw.githubusercontent.com/godotengine/godot-docs/3.4/img/ease_cheatsheet.png
const SLIDE_FRICTION := 0.1  # Friction when sliding on the ground. Equivalent to the movement in air, but with a little friction
const AIR_MOVE_TOWARD := 47  # When pressing forward in the air, how much it should stick to the aim direction

#~~~~~ PROJECTILES ~~~~~
const ROCKET_DELAY := 0.75  # Time before you can shoot another rocket
const ROCKET_START_OFFSET := Vector3(0, 0, 0)  # offest position from the player to throw the rocket
const ROCKET_SCENE_PATH := "res://Game/Common/MovementUtils/Rocket/rocket.tscn" # Path to the rocket scene

#---- EXPORTS -----
export(bool) var ROCKETS_ENABLED = true
export(bool) var SLIDE_ENABLED = true
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
var states := BitMap.new()  # player current states
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
var _last_floor_velocity := Vector3.ZERO  # Last floor velocity
var _last_wall_ride_tilt_direction := 0 # Used to avoid cancelling the head tilt animation at each frame
var _can_jump_on_fall := false # To allow jumping for a short period of time after exiting a platform
var _wall_ride_strategy : WallRideStrategy # Strategy to use for the wall ride

#==== ONREADY ====
onready var onready_paths := {
	"raycasts": {"root": $"RayCasts", "left": $"RayCasts/left", "right": $"RayCasts/right"},
	"camera": $"RotationHelper/Camera",
	"player_collision": $"PlayerCollision",
	"slide_collision": $"SlideCollision",
	"rotation_helper": $"RotationHelper",
	"UI": $"PlayerUI",
	"run_sound":
	{
		"pitch": $"Sounds/Run/Pitch",
		"unpitch": $"Sounds/Run/Pitch",
	},
	"jump_sound": $"Sounds/JumpSound",
	"wall_ride": $"Sounds/WallRide",
	"timers":
	{"update_speed": $"Timers/UpdateSpeed", "wall_ride_jump_lock": $"Timers/WallRideJumpLock", "fall_timer": $"Timers/FallTimer"},
	"tweens": 
	{
		"wall_jump_mix_mvt": $"WallJumpMixMovement",
		"wall_ride_tilt": $"WallRideTilt"
	},
	"slide_visual_effects": $"SlideVisualEffects",
	"rocket_launcher": $"RotationHelper/RocketLauncherPos/RocketLauncher",
	"rocket_fire_pos": $"RotationHelper/RocketLauncherPos/RocketFirePos",
	"toggle_ability_ui": $"ToggleAbilityUI",
	"wall_ride_strategy": {
		"standard":$"WallRideStrategy/Standard",
		"space_to_wall_ride":$"WallRideStrategy/SpaceToWallRide"
	},
	"trails": {
		"left":$"SlideVisualEffects/Left",
		"right":$"SlideVisualEffects/Right"
	}
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_init_states()


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_connect_signals()
	camera = onready_paths.camera
	rotation_helper = onready_paths.rotation_helper
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	onready_paths.timers.update_speed.start()
	onready_paths.run_sound.pitch.play()
	onready_paths.run_sound.unpitch.play()
	onready_paths.camera.fov = SettingsUtils.settings_data.gameplay.fov
	_choose_wall_ride_strategy()


func _process(_delta):
	_print_debug_data()
	_process_sounds()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(delta):
	_set_UI_data()
	_process_collision()
	_process_input(delta)
	_process_movement(delta)
	_process_states()
	_manage_slide_wallride_visual_effect()


# when an input is pressed
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * _get_mouse_sensitivity()))
		self.rotate_y(deg2rad(event.relative.x * _get_mouse_sensitivity() * -1))
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
func toggle_ability(name: String, enabled: bool, play_anim : bool = true) -> void:
	match name:
		GlobalConstants.ABILITY_SLIDE:
			if SLIDE_ENABLED != enabled:
				SLIDE_ENABLED = enabled
				if play_anim:
					onready_paths.toggle_ability_ui.toggle_slide(enabled)
		GlobalConstants.ABILITY_ROCKETS:
			if ROCKETS_ENABLED != enabled:
				ROCKETS_ENABLED = enabled
				onready_paths.rocket_launcher.visible = enabled
				if play_anim:
					onready_paths.toggle_ability_ui.toggle_rocket(enabled)


# returns the value of a specific state
func get_state_value(state_idx: int) -> bool:
	return states.get_bit(Vector2(state_idx, 0))


func set_state_value(state_idx: int, value: bool) -> void:
	states.set_bit(Vector2(state_idx, 0), value)


func checkpoint_process(cp_position: Vector3, cp_rotation: Vector3) -> void:
	if cp_position != null:
		transform.origin = cp_position
	if cp_rotation != null:
		_look_at_mangle(cp_rotation)
	vel = Vector3.ZERO


# process when trigerring a portal
func portal_process(exit_portal: Area) -> void:
	# sets the velocity direction to the exit point of the portal
	vel = vel.length() * exit_portal.get_global_forward_vector().normalized()
	# sets to the new position
	global_transform.origin = (
		exit_portal.global_transform.origin
		+ exit_portal.get_global_forward_vector().normalized() * exit_portal.scale
		+ exit_portal.get_global_forward_vector().normalized() * exit_portal.OFFSET
	)
	# sets to the new angle
	_look_at_mangle(exit_portal.get_rotation_degrees())

func set_trail_gradient_texture(gradient : GradientTexture) -> void:
	onready_paths.trails.left.get_surface_material(0).set_shader_param(TRAIL_GRADIENT_SHADER_PARAM, gradient)
	onready_paths.trails.right.get_surface_material(0).set_shader_param(TRAIL_GRADIENT_SHADER_PARAM, gradient)

##### PROTECTED METHODS #####
#---- General -----
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager,self,SignalManager.UPDATE_FOV,"_on_SignalManager_update_fov")
	DebugUtils.log_connect(SignalManager,self,SignalManager.UPDATE_WALL_RIDE_STRATEGY, "_on_SignalManager_update_wall_ride_strategy")

func _choose_wall_ride_strategy() -> void:
	if SettingsUtils.settings_data.gameplay.space_to_wall_ride:
		_wall_ride_strategy = onready_paths.wall_ride_strategy.space_to_wall_ride
	else:
		_wall_ride_strategy = onready_paths.wall_ride_strategy.standard

#---- Trenchbroom -----
func _set_TB_params() -> void:
	if "angle" in properties:
		rotation_degrees.y = properties["angle"]


#---- UI data -----
# sets the UI infos
func _set_UI_data() -> void:
	var ui = onready_paths.UI
	ui.set_speed(current_speed)


#---- Process collision -----
# Enables/disables some collisions depending on the states
func _process_collision():
	onready_paths.player_collision.disabled = get_state_value(states_idx.SLIDING)
	onready_paths.slide_collision.disabled = not get_state_value(states_idx.SLIDING)


#---- Camera -----
# Looks at an XYZ rotation vector
func _look_at_mangle(mangle: Vector3) -> void:
	if mangle != null:
		rotation_helper.rotation.x = deg2rad(mangle.x)
		rotation.y = deg2rad(mangle.y)
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -89, 89)
		rotation_helper.rotation_degrees = camera_rot


#---- Process states -----
# init states
func _init_states() -> void:
	states.create(Vector2(STATES_SIZE, 1))


# Input management
func _process_input(_delta):
	# Camera
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	# Standard movement
	input_movement_vector = Vector2()
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_FORWARD):
		input_movement_vector.y += 1
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_BACKWARD):
		input_movement_vector.y -= 1
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_LEFT):
		input_movement_vector.x -= 1
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_RIGHT):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()

	# Wished direction
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# Shooting
	if (
		Input.is_action_pressed(GlobalConstants.INPUT_ACTION_SHOOT)
		and not get_state_value(states_idx.SHOOTING)
		and ROCKETS_ENABLED
	):
		_shoot(cam_xform)

	# Slide/Wall ride
	if Input.is_action_just_pressed(GlobalConstants.INPUT_MVT_SLIDE) and SLIDE_ENABLED:
		_slide = true
	elif Input.is_action_just_released(GlobalConstants.INPUT_MVT_SLIDE):
		_slide = false
	if SLIDE_ENABLED: # slide also unlocks wall ride
		_wall_ride_strategy.process_input()

# Shoots a rocket
func _shoot(cam_xform: Transform) -> void:
	set_state_value(states_idx.SHOOTING, true)
	var rocket := _init_rocket(cam_xform)
	onready_paths.rocket_launcher.fire()
	if get_parent():
		get_parent().add_child(rocket)
	var _err = get_tree().create_timer(ROCKET_DELAY).connect(
		"timeout", self, "_remove_shooting_state"
	)


func _init_rocket(cam_xform: Transform) -> Area:
	var rocket = load(ROCKET_SCENE_PATH).instance()
	rocket.START_POS = onready_paths.rocket_fire_pos.global_transform.origin
	rocket.DIRECTION = -cam_xform.basis.z
	rocket.UP_VECTOR = Vector3(0, 1, 0)
	return rocket


#---- Process sounds -----
func _process_sounds() -> void:
	if (current_speed / SOUND_MAX_SPEED) * 4.0 > 0.0:
		if !onready_paths.run_sound.pitch.playing:
			onready_paths.run_sound.pitch.play()
		if !onready_paths.run_sound.unpitch.playing:
			onready_paths.run_sound.unpitch.play()
		onready_paths.run_sound.pitch.pitch_scale = clamp(
			current_speed / (SOUND_MAX_SPEED / 3.0), 0.0, 4.0
		)
		onready_paths.run_sound.unpitch.volume_db = clamp(
			linear2db(current_speed / (SOUND_MAX_SPEED / 2.0)), -72.0, 0.0
		)
	elif onready_paths.run_sound.pitch.playing:
		onready_paths.run_sound.pitch.stop()
	elif onready_paths.run_sound.unpitch.playing:
		onready_paths.run_sound.unpitch.stop()
	if (
		(get_state_value(states_idx.WALL_RIDING) or get_state_value(states_idx.SLIDING))
		and not onready_paths.wall_ride.playing
	):
		onready_paths.wall_ride.play()
	elif (
		!(get_state_value(states_idx.WALL_RIDING) or get_state_value(states_idx.SLIDING))
		and onready_paths.wall_ride.playing
	):
		onready_paths.wall_ride.stop()


#---- Process movement -----
# process for the movement
func _process_movement(delta):
	# _debug_process_movement(delta)
	vel -= _last_floor_velocity  # removes the floor velocity to not process it in the movement
	# Wall ride wall check
	if _RC_wall_direction == 0:  # First contact with wall
		_find_wall_direction()

	# Movement process
	if _wall_ride_strategy.can_wall_ride(is_on_floor(), _RC_wall_direction, _wall_ride_lock):
		_wall_ride_movement(delta)
		# rotates the camera
		_set_wall_ride_camera_tilt(_RC_wall_direction  * WALL_RIDE_TILT_ANGLE, _RC_wall_direction)
	else:
		_set_wall_ride_camera_tilt(0,0)
		_reset_wallride_raycasts()
		if is_on_floor():
			_ground_movement(delta)
		else:
			_air_movement(delta)
	_add_movement_queue_to_vel()
	_override_velocity()
	# Move and slide + update speed
	var snap = (
		Vector3.ZERO
		if Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)
		else -get_floor_normal()
	)
	vel = move_and_slide_with_snap(vel, snap, Vector3.UP, true, 4, MAX_SLOPE_ANGLE, false)
	vel += get_floor_velocity()
	_last_floor_velocity = get_floor_velocity()
	current_speed = Vector3(vel.x, 0, vel.z).length()


# overrides the velocity with the _override_velocity_vector value
func _override_velocity():
	if _override_velocity_vector != null:
		vel = _override_velocity_vector
		_override_velocity_vector = null


func _find_wall_direction() -> void:
	if onready_paths.raycasts.right.is_colliding():
		_RC_wall_direction = -1
	elif onready_paths.raycasts.left.is_colliding():
		_RC_wall_direction = 1


# wall ride movement management
func _wall_ride_movement(delta: float) -> void:
	var rc: RayCast = _find_raycast_from_direction(_RC_wall_direction)
	if rc != null and rc.is_colliding():  # if on an "acceptable" wall
		if !get_state_value(states_idx.WALL_RIDING):  # first contact with the wall, snap the player to it
			_init_wall_riding(rc)
		var wall_fw = _get_wall_fw_vector(rc)
		if _wall_ride_strategy.should_wall_jump():
			_wall_jump(wall_fw)
		else:
			_wall_ride_process(rc, wall_fw, delta)
	else:  # resets the wall ride direction
		_RC_wall_direction = 0


# returns the raycast associated with the last raycast direction (_RC_wall_direction)
func _find_raycast_from_direction(direction: int):
	match direction:
		1:
			return onready_paths.raycasts.left
		-1:
			return onready_paths.raycasts.right
		_:
			return null


# initializes wall riding variables
func _init_wall_riding(rc: RayCast) -> void:
	transform.origin = (
		rc.get_collision_point()
		+ rc.get_collision_normal() * WALL_RIDE_WALL_DISTANCE
	)  # keep a small distance from the wall to avoid getting stuck in it
	set_state_value(states_idx.WALL_RIDING, true)
	_wall_ride_strategy.wall_riding = true

# returns the vector aligned with the wall, to a forward direction of the player
func _get_wall_fw_vector(rc: RayCast) -> Vector3:
	var wall_normal = rc.get_collision_normal().normalized()  # normal of the wall, should be the aligned with the player x axis
	# FIXME : probably an issue if the player tries to wall_ride backwards
	return (wall_normal.cross(Vector3.UP) * -_RC_wall_direction).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)


# wall jump
func _wall_jump(wall_fw: Vector3) -> void:
	if get_state_value(states_idx.WALL_RIDING):
		_init_wall_ride_lock()
	vel += (wall_fw.rotated(Vector3.UP, WALL_JUMP_ANGLE * -_RC_wall_direction) * WALL_JUMP_BOOST)
	vel += Vector3.UP * WALL_JUMP_UP_BOOST
	if not onready_paths.jump_sound.playing:
		onready_paths.jump_sound.play()


func _wall_ride_process(rc: RayCast, wall_fw: Vector3, delta: float) -> void:
	_keep_wallride_raycasts_perpendicular(rc)
	set_state_value(states_idx.WALL_RIDING, true)
	_wall_ride_strategy.wall_riding = true
	var vel_dir = Vector3(wall_fw.x, WALL_RIDE_ASCEND_AMOUNT * delta, wall_fw.z).normalized()
	vel = vel_dir * vel.length()


func _init_wall_ride_lock() -> void:
	set_state_value(states_idx.WALL_RIDING, false)
	_wall_ride_strategy.wall_riding = false
	onready_paths.timers.wall_ride_jump_lock.start()  # to avoid sticking and accelerating back on the wall after jumping
	_wall_ride_lock = true
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_FORWARD):  # FIXME : probably creates a bug that can make the player wall jump easily to the same wall (but that might make a cool mechanic)
		var tween = onready_paths.tweens.wall_jump_mix_mvt
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
	raycast_dir_vect = rc.get_global_transform().origin - rc.get_collision_point()
	angle = wall_normal_vect.signed_angle_to(raycast_dir_vect, Vector3.UP)
	onready_paths.raycasts.root.rotate_y(-angle)


# resets the wallride raycasts to their standard rotation value
func _reset_wallride_raycasts() -> void:
	onready_paths.raycasts.root.rotation = Vector3(0, 0, 0)


# movement management when on the ground
func _ground_movement(delta: float) -> void:
	_apply_friction(delta)
	_accelerate(
		Vector3(dir.x, 0, dir.z).normalized(), GROUND_TARGET_SPEED, GROUND_ACCELERATION, delta
	)
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP):
		_ground_jump()


# when jumping and on the ground
func _ground_jump() -> void:
	vel.y += JUMP_POWER  # FIXME : delta not used here ?
	if get_state_value(states_idx.SLIDING):
		_slide_jump()
	onready_paths.jump_sound.play()


# Executed when jumping while sliding
func _slide_jump():
	var added_vel = Vector3(vel.x, 0, vel.z).normalized() * SLIDE_SPEED_BONUS_JUMP
	if (vel + added_vel).length() <= SLIDE_JUMP_SPEED_CAP:
		var slide_speed_cap_percents = ease((vel + added_vel).length()/SLIDE_JUMP_SPEED_CAP, SLIDE_JUMP_SPEED_CAP_EASE)
		vel = Vector3(vel.x, 0, vel.z).normalized() * slide_speed_cap_percents * SLIDE_JUMP_SPEED_CAP
	elif vel.length() <= SLIDE_JUMP_SPEED_CAP:
		vel = Vector3(vel.x, 0, vel.z).normalized() * SLIDE_JUMP_SPEED_CAP
	_slide = false
	self.rotate_object_local(Vector3(1, 0, 0), PI / 4)
	rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
	set_state_value(states_idx.SLIDING, false)


# applies friction, mostly for when on floor
func _apply_friction(delta: float):
	var drop := 0.0
	if current_speed <= STOP_SPEED:
		vel.x = 0
		vel.z = 0
		return  # no need to compute things further, the player is stopped
	var control := 0.0
	if !Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP):
		var friction := SLIDE_FRICTION if _slide else GROUND_FRICTION
		control = current_speed
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

# simpler than _accelerate, no need to do something complex
func _deccelerate(wish_speed: float, deccel: float, delta : float):
	if wish_speed < vel.length():
		var vel_dir = vel.normalized()
		var add_wish_speed_vel = (vel.length() - wish_speed) * deccel * FunctionUtils.get_delta_compared_to_physics_fps(delta) 
		vel.x = vel_dir.x * (wish_speed + add_wish_speed_vel)
		vel.z = vel_dir.z * (wish_speed + add_wish_speed_vel)

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
	elif(input_movement_vector == Vector2.ZERO): # not pressing anything, should decelerate slowly
		_deccelerate(0,AIR_NO_INPUT_DECELERATION,delta)
	else:  # accelerate and strafe
		_accelerate(wish_dir, AIR_TARGET_SPEED, AIR_ACCELERATION, delta)
	vel.y += GRAVITY * delta
	# allows for a jump shortly after exiting a platform
	if Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP) and _can_jump_on_fall:
		vel.y = 0
		_ground_jump()
		_can_jump_on_fall = false


# adds the vectors stored in the _add_velocity_vector_queue to velocity
func _add_movement_queue_to_vel():
	for vect in _add_velocity_vector_queue:
		vel += vect
	_add_velocity_vector_queue = []

# adds an 'head tilt' when wall riding
func _set_wall_ride_camera_tilt(angle : float, wall_ride_dir : int) -> void:
	if wall_ride_dir != _last_wall_ride_tilt_direction:
		DebugUtils.log_tween_stop_all(onready_paths.tweens.wall_ride_tilt)
		DebugUtils.log_tween_interpolate_property(onready_paths.tweens.wall_ride_tilt,
		rotation_helper,
		"rotation:z",
		rotation_helper.rotation.z,
		angle,
		WALL_RIDE_TILT_SPEED)
		DebugUtils.log_tween_start(onready_paths.tweens.wall_ride_tilt)
		_last_wall_ride_tilt_direction = wall_ride_dir

#---- Process states -----
# updates the states
func _process_states():
	if _slide:
		if not get_state_value(states_idx.SLIDING) and is_on_floor():
			self.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
			rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
			set_state_value(states_idx.SLIDING, true)
	if not is_on_floor() and not get_state_value(states_idx.IN_AIR):
		set_state_value(states_idx.IN_AIR, true)
	elif is_on_floor() and get_state_value(states_idx.IN_AIR):
		vel -= get_floor_velocity()  # HACK : to avoid adding speed by just jumping on a moving platform. probably some scenarios where this won't be ideal
		set_state_value(states_idx.IN_AIR, false)
	if current_speed != 0 and not get_state_value(states_idx.MOVING):
		set_state_value(states_idx.MOVING, true)
	if (
		get_state_value(states_idx.SLIDING)
		and (not Input.is_action_pressed(GlobalConstants.INPUT_MVT_SLIDE))
	):
		self.rotate_object_local(Vector3(1, 0, 0), PI / 4)
		rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
		set_state_value(states_idx.SLIDING, false)
	if (
		get_state_value(states_idx.WALL_RIDING)
		and _wall_ride_strategy.wall_ride_exited(is_on_floor(), _RC_wall_direction)
	):
		set_state_value(states_idx.WALL_RIDING, false)
		_wall_ride_strategy.wall_riding = false

func _manage_slide_wallride_visual_effect() -> void:
	var look_at_vect = self.global_transform.origin - Vector3(vel.x,0.0,vel.z)
	var visual_effect_slide_offset = Vector3(0.0,0.0,-1.0)
	var visual_effect_wall_ride_offset = Vector3(1.0 * _RC_wall_direction,2.0,-1.0)
	# Refactor : make a method to check if a vector can be looked at (used a fair amount of times)
	if(onready_paths.slide_visual_effects.global_transform.origin != look_at_vect and look_at_vect != Vector3.ZERO and look_at_vect != Vector3.UP and look_at_vect != Vector3.DOWN):
		onready_paths.slide_visual_effects.look_at(look_at_vect, Vector3.UP)
	if get_state_value(states_idx.SLIDING):
		onready_paths.slide_visual_effects.visible = true
		onready_paths.slide_visual_effects.transform.origin = visual_effect_slide_offset
	elif get_state_value(states_idx.WALL_RIDING):
		onready_paths.slide_visual_effects.visible = true
		onready_paths.slide_visual_effects.rotation.z = PI/2.0 * _RC_wall_direction
		onready_paths.slide_visual_effects.transform.origin = visual_effect_wall_ride_offset
	else:
		onready_paths.slide_visual_effects.visible = false

func _get_mouse_sensitivity() -> float:
	return SettingsUtils.settings_data.controls.mouse_sensitivity

##### SIGNAL MANAGEMENT #####
func _remove_shooting_state():
	set_state_value(states_idx.SHOOTING, false)

func _on_UpdateSpeed_timeout():
	SignalManager.emit_speed_updated(current_speed)
	SignalManager.emit_position_updated(self.global_transform.origin)

func _on_WallRideJumpLock_timeout():
	_wall_ride_lock = false

func _on_FloorDetectArea_body_exited(_body:Node):
	# Just exited a floor and not jumping
	if not is_on_floor() and not Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP):
		_can_jump_on_fall = true
		onready_paths.timers.fall_timer.start()
		
func _on_FallTimer_timeout():
	_can_jump_on_fall = false

func _on_SignalManager_update_fov(value : float):
	onready_paths.camera.fov = value

func _on_SignalManager_update_wall_ride_strategy() -> void:
	_choose_wall_ride_strategy()

#### DEBUG #####
func _debug_process_movement(_delta: float):
	var rc: RayCast
	var rc_dir := 0
	if onready_paths.raycasts.left.is_colliding():
		rc = onready_paths.raycasts.left
		rc_dir = -1
	elif onready_paths.raycasts.right.is_colliding():
		rc = onready_paths.raycasts.right
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


func _print_debug_data() -> void:
	DebugDraw.set_text("velocity", vel)
	DebugDraw.set_text("on_floor", is_on_floor())
	DebugDraw.set_text("last floor vel", _last_floor_velocity)
