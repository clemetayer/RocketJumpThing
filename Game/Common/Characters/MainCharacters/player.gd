# tool
extends RigidBody
class_name Player
# Script for the player

"""
- TODO : Use a rigid body instead ? Shifty’s Manifesto is a bit spooky...
- TODO : Maybe refactor a bit this script in general, it's getting hard to read
- TODO : Explode the rockets on right click ? charge rocket on right click ?
- TODO : improve BHop ~ Actually, maybe it is fine the way it is...
- TODO : Perhaps change the side movement to air strafing, sliding to the left or right feels a bit weird actually... Should strafe 'harder' to the direction in that case
- TODO : Create as a Qodot entity to be able to change the start rotation for instance
- FIXME : Use the wall collision info to compute wall ride ~ To try, but there is a risk that it might either stick to the wall too well or not much...
- FIXME : Rocket not adding velocity when wall riding ~ It does, but it feels a bit weird
- FIXME : sliding on slopes stops the player
- FIXME : Reverse strafing accelerating player (moving mouse to the right and going forward left for instance). Maybe it can be desirable, idk, it doesn't feel that weird...
"""

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
#~~~~ MOVEMENT ~~~~~
#==== GLOBAL =====
const GRAVITY := -80  # Gravity applied to the player
const JUMP_POWER := 33  # Power applied when jumping
const MAX_SLOPE_ANGLE := 45  # Max slope angle where you stop sliding
const STOP_SPEED := 1.0  # Minimum speed to consider the player "stopped"

#==== AIR =====
const AIR_TARGET_SPEED := 110  # Target acceleration when just pressing forward in the air
const AIR_ACCELERATION := 0.75  # Acceleration in air to get to the AIR_TARGET_SPEED

#==== WALL RIDE =====
const WALL_RIDE_ASCEND_AMOUNT := 10.0  # How much the player ascend during a wall ride
const WALL_JUMP_BOOST := 20.0  # How much speed is given to the player when jumping while wall riding
const WALL_JUMP_UP_BOOST := 10.0  # The up vector that is added when jumping off a wall
const WALL_JUMP_ANGLE := PI / 4  # Angle from the wall forward vector when wall jumping
const WALL_JUMP_MIX_DIRECTION_TIME := 0.5  # How much time after the jumping from a wall should override the forward movement (to avoid a bug that makes the player sticks to the wall)

#==== GROUND =====
const GROUND_TARGET_SPEED := 50  # Ground target speed
const GROUND_ACCELERATION := 4.5  # Acceleration on the ground
const GROUND_DECCELERATION := 4.5  # Decceleration when on ground
const GROUND_FRICTION := 5.0  # Ground friction 
const SLIDE_SPEED_BONUS_JUMP := 50  # Speed added when jumping after a slide
const SLIDE_FRICTION := 0.5  # Friction when sliding on the ground. Equivalent to the movement in air, but with a little friction 

#~~~~~ PROJECTILES ~~~~~ 
const ROCKET_DELAY := 1.0  # Time before you can shoot another rocket
const ROCKET_START_OFFSET := Vector3(0, -0.5, 0)  # offest position from the player to throw the rocket
const ROCKET_SCENE_PATH := "res://Game/Common/MovementUtils/Rocket/Rocket.tscn"  # Path to the rocket scene

#---- EXPORTS -----
export (Dictionary) var PATHS = {
	"camera": NodePath("."),
	"rotation_helper": NodePath("."),
	"global_rotation_helper": NodePath("."),
	"UI": NodePath(".")
}
export (bool) var ROCKETS_ENABLED = true
export (bool) var SLIDE_ENABLED = true
export (Dictionary) var properties setget set_properties

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
var global_rotation_helper  # global rotation helper

#==== PRIVATE ====
var _add_velocity_vector_queue := []  # queue to add the vector to the velocity on the next process (used to make external elements interact with the player velocity)
var _slide := false  # used to buffer a slide when in air
var _RC_wall_direction := 0  # 1 if the raycasts aims for the right wall, -1 if the raycast aims for the left wall, 0 if not aiming for any wall
var _mix_to_direction_amount := 1.0  # Used after wall jumping and pressing forward, to not stick to the wall. Varies between 0 and 1.
var _charge_shot_time := 0  # time when the shot key was pressed (as unix timestamp, millis)
var _is_on_floor := false  # true if the character is on the floor

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(PATHS.camera)
	rotation_helper = get_node(PATHS.rotation_helper)
	global_rotation_helper = get_node(PATHS.global_rotation_helper)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Timers/UpdateSpeed.start()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(delta):
	# DebugDraw.set_text("current_speed", current_speed)
	# DebugDraw.draw_line_3d(self.transform.origin, self.transform.origin + dir, Color(0, 1, 1))
	# DebugDraw.draw_line_3d(
	# 	self.translation, self.transform.origin + Vector3(vel.x, 0, vel.z), Color(0, 1, 0)
	# )
#	DebugDraw.draw_line_3d(
#		self.transform.origin, self.transform.origin + self.transform.basis.x, Color(1, 0, 0)
#	)
#	DebugDraw.draw_line_3d(
#		self.transform.origin, self.transform.origin + self.transform.basis.y, Color(0, 1, 0)
#	)
#	DebugDraw.draw_line_3d(
#		self.transform.origin, self.transform.origin + self.transform.basis.z, Color(0, 0, 1)
#	)
	_set_UI_data()
	_process_collision()
	_process_input(delta)
	_process_movement(delta)
	_process_states()


# when an input is pressed
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
		global_rotation_helper.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		rotation_helper.rotation_degrees = camera_rot


##### PUBLIC METHODS #####
# Adds some vector to move the player (to be queued)
func add_velocity_vector(vector: Vector3):
	_add_velocity_vector_queue.append(vector)


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'angle' in properties:
		rotation_degrees.y = properties.angle


#==== Others =====
# sets the UI infos
func _set_UI_data() -> void:
	current_speed = vel.length()
	var ui := get_node(PATHS.UI)
	ui.set_speed(current_speed)


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	_is_on_floor = _check_is_on_floor(state)
	linear_velocity = vel


# Enables/disables some collisions depending on the states
func _process_collision():
	$PlayerCollision.disabled = states.has("sliding")
	$SlideCollision.disabled = not states.has("sliding")


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

	# Jumping
	if _is_on_floor:
		if Input.is_action_pressed("movement_jump"):
			if states.has("sliding"):
				vel += Vector3(vel.x, 0, vel.z).normalized() * SLIDE_SPEED_BONUS_JUMP
				_slide = false
				global_rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
				rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
				states.erase("sliding")
			vel.y += JUMP_POWER

	# Shooting
	if Input.is_action_pressed("action_shoot") and not states.has("shooting") and ROCKETS_ENABLED:
		states.append("shooting")
		var rocket = load(ROCKET_SCENE_PATH).instance()
		rocket.START_POS = transform.origin + transform.basis * ROCKET_START_OFFSET
		rocket.DIRECTION = -cam_xform.basis.z
		rocket.UP_VECTOR = Vector3(0, 1, 0)
		get_parent().add_child(rocket)
		var _err = get_tree().create_timer(ROCKET_DELAY).connect(
			"timeout", self, "remove_shooting_state"
		)

	# Slide
	if Input.is_action_just_pressed("movement_slide") and SLIDE_ENABLED:
		_slide = true
	elif Input.is_action_just_released("movement_slide"):
		_slide = false

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# process for the movement
func _process_movement(delta):
	_debug_process_movement(delta)

	# Wall ride wall check
	if _RC_wall_direction == 0:  # First contact with wall
		if $GlobalRotation/RayCasts/RayCastWallMinus.is_colliding():
			_RC_wall_direction = -1
		elif $GlobalRotation/RayCasts/RayCastWallPlus.is_colliding():
			_RC_wall_direction = 1

	# Movement process
	if (
		not _is_on_floor
		and (true or states.has("wall_riding"))
		and _slide
		and _RC_wall_direction != 0
	):
		_wall_ride_movement(delta)
	else:
		_reset_wallride_raycasts()
		if _is_on_floor:
			_ground_movement(delta)
		else:
			_air_movement(delta)
	_add_movement_queue_to_vel()
	# vel = move_and_slide(vel, Vector3.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	current_speed = vel.length()


# updates the states
func _process_states():
	if _slide:
		if not states.has("sliding") and _is_on_floor:
			global_rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
			rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
			states.append("sliding")
	if _is_on_floor and not states.has("in_air"):
		states.append("in_air")
	if current_speed != 0 and not states.has("moving"):
		states.append("moving")
	if states.has("sliding") and (not Input.is_action_pressed("movement_slide")):
		global_rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
		rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
		states.erase("sliding")
	if (
		states.has("wall_riding")
		and (
			not Input.is_action_pressed("movement_slide")
			or _is_on_floor
			or _RC_wall_direction == 0
		)
	):
		states.erase("wall_riding")


# verifies if the player is on the floor (to update the _is_on_floor value)
func _check_is_on_floor(state: PhysicsDirectBodyState) -> bool:
	for i in range(state.get_contact_count()):  # if at least one contact has an angle from the up vector inferior to the max slope angle, then we are on floor 
		if state.get_contact_local_normal(i).angle_to(Vector3.UP):
			return true
	return false


func _wall_ride_movement(delta: float) -> void:
	var rc: RayCast = (
		$RayCasts/RayCastWallPlus
		if _RC_wall_direction == 1
		else $RayCasts/RayCastWallMinus if _RC_wall_direction == -1 else null
	)
	if rc != null and rc.is_colliding():  # if on an "acceptable" wall
		var wall_normal = rc.get_collision_normal().normalized()  # normal of the wall, should be the aligned with the player x axis
		var wall_fw = (wall_normal.cross(Vector3.UP) * -_RC_wall_direction).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)
		if Input.is_action_pressed("movement_jump"):
			if states.has("wall_riding"):
				states.remove("wall_riding")
			if Input.is_action_pressed("movement_forward"):
				var tween = get_node("WallJumpMixMovement")
				if tween.is_active():
					tween.stop_all()
				tween.interpolate_property(
					self, "_mix_to_direction_amount", 0.0, 1.0, WALL_JUMP_MIX_DIRECTION_TIME
				)
				tween.start()
			vel += (
				wall_fw.rotated(Vector3.UP, WALL_JUMP_ANGLE * -_RC_wall_direction)
				* WALL_JUMP_BOOST
			)
			vel += Vector3.UP * WALL_JUMP_UP_BOOST
		else:
			_keep_wallride_raycasts_perpendicular()
			if not states.has("wall_riding"):
				states.append("wall_riding")
			var vel_dir = Vector3(wall_fw.x, WALL_RIDE_ASCEND_AMOUNT * delta, wall_fw.z).normalized()
			vel = vel_dir * vel.length()
		# DebugDraw.draw_line_3d(transform.origin, transform.origin + vel, Color(0, 1, 1))
	else:
		_RC_wall_direction = 0


func _ground_movement(delta: float) -> void:
	_apply_friction(delta)
	_accelerate(
		Vector3(dir.x, 0, dir.z).normalized(), GROUND_TARGET_SPEED, GROUND_ACCELERATION, delta
	)
	vel.y = JUMP_POWER if Input.is_action_pressed("movement_jump") else 0


func _air_movement(delta: float) -> void:
	var wish_dir := Vector3(dir.x, 0, dir.z).normalized()
	if input_movement_vector.x == 0 && input_movement_vector.y == 1:  # pressing forward only, forces the velocity direction to the wishdir
		if current_speed < AIR_TARGET_SPEED:  # accelerate if not reached the target speed yet
			_accelerate(wish_dir, AIR_TARGET_SPEED, AIR_ACCELERATION, delta)
		var linear_speed := Vector3(vel.x, 0, vel.z).length()  # keep the current speed
		var direction_vec := wish_dir * linear_speed  # direction and speed of the velocity on a linear axis
		vel.x = direction_vec.x
		vel.z = direction_vec.z
	else:  # accelerate and strafe
		_accelerate(wish_dir, AIR_TARGET_SPEED, AIR_ACCELERATION, delta)
	vel.y += GRAVITY * delta


func _apply_friction(delta: float):
	vel.y = 0.0
	var drop := 0.0
	if current_speed <= STOP_SPEED:
		vel.x = 0
		vel.z = 0
		return  # no need to compute things further, the player is stopped
	var control := 0.0
	if _is_on_floor && ! Input.is_action_pressed("movement_jump"):
		var friction := SLIDE_FRICTION if _slide else GROUND_FRICTION
		control = GROUND_DECCELERATION if current_speed < GROUND_DECCELERATION else current_speed
		drop += control * friction * delta
	var speed_multiplier := 1.0  # more like a "de"multiplier in most cases
	if current_speed > 0:
		speed_multiplier = abs(current_speed - drop) / current_speed
	vel.x *= speed_multiplier
	vel.z *= speed_multiplier


func _accelerate(wish_dir: Vector3, wish_speed: float, accel: float, delta: float):
	var project_speed = vel.dot(wish_dir)  # dot product between the velocity and the wishdir. equivalent of currentspeed in Quake III code, which is the speed on the wishdir (and not the "real" speed vel.length()), but allows air strafing, which is very cool
	var add_speed = wish_speed - project_speed
	if add_speed > 0:  # accelerate only if needed
		var accel_amount := clamp(accel * delta * wish_speed, 0.0, add_speed)  # acceleration amount 
		vel.x += accel_amount * wish_dir.x
		vel.z += accel_amount * wish_dir.z


# resets the wallride raycasts to their standard rotation value
func _reset_wallride_raycasts() -> void:
	$GlobalRotation/RayCasts.rotation = Vector3(0, 0, 0)


# sets the wallride raycast rotations to stay perpendicular to the wall it is colliding with
func _keep_wallride_raycasts_perpendicular() -> void:
	var rc: RayCast
	var wall_normal_vect: Vector3  # normal of the wall returned by the raycast
	var raycast_dir_vect: Vector3  # direction to the raycast from the collision point
	var angle: float  # angle between wall_normal_vect and raycast_dir_vect
	if _RC_wall_direction == -1:  # right raycast
		rc = $RayCasts/RayCastWallMinus
		wall_normal_vect = rc.get_collision_normal()
		raycast_dir_vect = rc.global_transform.origin - rc.get_collision_point()
		angle = wall_normal_vect.signed_angle_to(raycast_dir_vect, Vector3.UP)
		# DebugDraw.set_text("angle", angle)
		$RayCasts.rotate_y(-angle)
	elif _RC_wall_direction == 1:  # left raycast
		rc = $RayCasts/RayCastWallPlus
		wall_normal_vect = rc.get_collision_normal()
		raycast_dir_vect = rc.global_transform.origin - rc.get_collision_point()
		angle = wall_normal_vect.signed_angle_to(raycast_dir_vect, Vector3.UP)
		# DebugDraw.set_text("angle", angle)
		$RayCasts.rotate_y(-angle)


# adds the vectors stored in the _add_velocity_vector_queue to velocity
func _add_movement_queue_to_vel():
	for vect in _add_velocity_vector_queue:
		vel += vect
	_add_velocity_vector_queue = []


##### SIGNAL MANAGEMENT #####
func remove_shooting_state():
	if states.has("shooting"):
		states.erase("shooting")


#### DEBUG #####
func _debug_process_movement(_delta: float):
	var rc: RayCast
	var rc_dir := 0
	if $GlobalRotation/RayCasts/RayCastWallMinus.is_colliding():
		rc = $GlobalRotation/RayCasts/RayCastWallMinus
		rc_dir = -1
	elif $GlobalRotation/RayCasts/RayCastWallPlus.is_colliding():
		rc = $GlobalRotation/RayCasts/RayCastWallPlus
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


func _on_UpdateSpeed_timeout():
	SignalManager.emit_speed_updated(current_speed)
