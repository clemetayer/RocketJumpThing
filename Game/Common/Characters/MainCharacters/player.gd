extends KinematicBody
class_name Player
# Script for the player

"""
- TODO : Make strafe acceleration logarithmic - Actually, no.
- TODO : Use a rigid body instead ? Shifty’s Manifesto is a bit spooky...
- TODO : improve BHop
- TODO : Actually, air strafing feels... weird...
- TODO : When wall riding and jumping, add a boost to exit the wall
- FIXME : Rocket not exploding when too close to a wall
- FIXME : Make rocket explode at the raycast collision point
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
const FLOOR_POWER := -1  # Standard gravity power applied to the player when is on floor (to avoid gravity to keep decreasing on floor)
const MAX_SLOPE_ANGLE := 45  # Max slope angle where you stop sliding
const PLAYER_HEIGHT := 2  # Player height
const PLAYER_WIDTH := 1  # Player width

#==== AIR =====
const AIR_TARGET_SPEED := 130  # Target acceleration when just pressing forward in the air
const AIR_ADD_STRAFE_SPEED := .75  # Speed that is added during a strafe
const AIR_BACK_DECCELERATE := 0.98  # Speed decceleration when pressing an opposite direction to the velocity
const AIR_STANDARD_DECCELERATE := 0.985  # Speed decceleration when not pressing anything
const AIR_ACCELERATION := 1.0  # Accel	eration in air to get to the AIR_TARGET_SPEED
const AIR_STRAFE_STEER_POWER := 50.0  # Power of the turn when air strafing
const AIR_SWAY_ANGLE_MINUS_ANGLE := PI / 4  # Angle to retract from the wished direction (target direction when swaying)
const AIR_SWAY_SPEED := 100  # Speed for the velocity to get to the desired sway angle

#==== WALL RIDE =====
const WALL_RIDE_Z_ANGLE := PI / 2  # Angle from the wall on the z axis when wall riding
const WALL_RIDE_ASCEND_AMOUNT := 10.0  # How much the player ascend during a wall ride

#==== GROUND =====
const GROUND_TARGET_SPEED := 50  # Ground target speed
const GROUND_ACCELERATION := 4.5  # Acceleration on the ground to get to GROUND_TARGET_SPEED
const SLIDE_SPEED_BONUS_GROUND := 50  # Speed added when starting the slide
const SLIDE_SPEED_BONUS_JUMP := 50  # Speed added when jumping after a slide
const SLIDE_STEER_POWER := 100  # How much the player can steer when sliding

#~~~~~ PROJECTILES ~~~~~ 
const ROCKET_DELAY := 1.0  # Time before you can shoot another rocket
const ROCKET_START_OFFSET := Vector3(0, 1, -1)  # offest position from the player to throw the rocket
const ROCKET_SCENE_PATH := "res://Game/Common/MovementUtils/Rocket/Rocket.tscn"  # Path to the rocket scene

#---- EXPORTS -----
export (Dictionary) var PATHS = {"camera": NodePath("."), "rotation_helper": NodePath(".")}

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
var _slide := false  # used to buffer a slide when in air
var _RC_wall_direction := 0  # 1 if the raycasts aims for the right wall, -1 if the raycast aims for the left wall, 0 if not aiming for any wall

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(PATHS.camera)
	rotation_helper = get_node(PATHS.rotation_helper)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(delta):
	DebugDraw.set_text("current_speed", current_speed)
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
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


##### PUBLIC METHODS #####
# Adds some vector to move the player (to be queued)
func add_velocity_vector(vector: Vector3):
	_add_velocity_vector_queue.append(vector)


##### PROTECTED METHODS #####
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
	if is_on_floor():
		if Input.is_action_pressed("movement_jump"):
			if states.has("sliding"):
				vel += Vector3(vel.x, 0, vel.z).normalized() * SLIDE_SPEED_BONUS_JUMP
				_slide = false
				rotate_object_local(Vector3(1, 0, 0), PI / 4)
				rotation_helper.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
				states.erase("sliding")
			vel.y += JUMP_POWER
		else:
			vel.y = FLOOR_POWER

	# Shooting
	if Input.is_action_pressed("action_shoot") and not states.has("shooting"):
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
	if Input.is_action_just_pressed("movement_slide"):
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
		if $RayCasts/RayCastWallMinus.is_colliding():
			_RC_wall_direction = -1
		elif $RayCasts/RayCastWallPlus.is_colliding():
			_RC_wall_direction = 1
	# Movement process
	if (
		not is_on_floor()
		and (is_on_wall() or states.has("wall_riding"))
		and _slide
		and _RC_wall_direction != 0
	):
		var rc: RayCast = (
			$RayCasts/RayCastWallPlus
			if _RC_wall_direction == 1
			else $RayCasts/RayCastWallMinus if _RC_wall_direction == -1 else null
		)
		if rc != null and rc.is_colliding():  # if on an "acceptable" wall 
			if not states.has("wall_riding"):
				states.append("wall_riding")
			var wall_normal = rc.get_collision_normal().normalized()  # normal of the wall, should be the aligned with the player x axis
			var wall_up = Vector3(0, 1, 0)  # Up direction from the wall (always that direction)
			var wall_fw = (wall_normal.cross(wall_up) * -_RC_wall_direction).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)
			var vel_dir = Vector3(wall_fw.x, WALL_RIDE_ASCEND_AMOUNT * delta, wall_fw.z).normalized()
			vel = vel_dir * vel.length()
			DebugDraw.draw_line_3d(transform.origin, transform.origin + vel, Color(0, 1, 1))
			vel = move_and_slide(vel, wall_up, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
		else:
			_RC_wall_direction = 0
	else:
		_process_hvel(delta)


# updates the states
func _process_states():
	DebugDraw.set_text("is_on_floor", is_on_floor())
	DebugDraw.set_text("states", states)
	if is_on_floor() and not states.has("in_air"):
		states.append("in_air")
	if current_speed != 0 and not states.has("moving"):
		states.append("moving")
	if states.has("sliding") and (not Input.is_action_pressed("movement_slide")):
		rotate_object_local(Vector3(1, 0, 0), PI / 4)
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


# processes the horizontal velocity when not wall riding
func _process_hvel(delta: float) -> void:
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * GRAVITY
	var hvel := _compute_hvel(Vector2(vel.x, vel.z), delta)
	vel.x = hvel.x
	vel.z = hvel.y
	for vect in _add_velocity_vector_queue:
		vel += vect
	_add_velocity_vector_queue = []
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


# computes the horizontal velocity
func _compute_hvel(p_vel: Vector2, delta: float) -> Vector2:
	current_speed = p_vel.length()
	if is_on_floor():
		return _compute_ground_hvel(p_vel, delta)
	else:
		return _compute_air_hvel(p_vel, delta)


# computes the horizontal velocity when in air
func _compute_air_hvel(p_vel: Vector2, delta: float) -> Vector2:
	var dir_2D = Vector2(dir.x, dir.z)
	if input_movement_vector.x == 0:  # no left/right input
		if input_movement_vector.y != 0:  # forward/backward input
			return _mvt_air_fw(p_vel, delta, dir_2D)
		else:  # just keeps the same vector (no horizontal movement input) and deccelerate slightly (NOTE : Maybe cancel the decceleration with shift ?)
			return _mvt_air_bw(p_vel)
	else:  # left/right input
		if input_movement_vector.y != 0:  # this is where you should gain a lot of speed, by "snaking" or strafing
			return _mvt_air_strafe(p_vel, dir_2D, delta)
		else:  # should sway left/right without modifying the speed (and also goes towards the mouse vector)
			return _mvt_air_sway(dir_2D, p_vel, delta)


# Movement when in air when going straight forward
func _mvt_air_fw(p_vel: Vector2, delta: float, dir_2D: Vector2) -> Vector2:
	if abs(dir_2D.angle_to(p_vel)) <= PI / 2:  # keeps the same speed, but goes instantly toward what the player is aiming
		var air_accel_bonus = 0.0
		if current_speed < AIR_TARGET_SPEED:  # adds a bonus to get to the target speed, computed as y=(atan(x * AIR_ACCELERATION)/(PI/2)) * TARGET_SPEED
			var x = tan((current_speed / AIR_TARGET_SPEED) * (PI / 2)) / AIR_ACCELERATION  # current x value for the function above
			air_accel_bonus = (
				((atan((x + delta) * AIR_ACCELERATION) / (PI / 2)) * AIR_TARGET_SPEED)  # new speed should be the next delta x in the function above
				- current_speed
			)
		return dir_2D * (p_vel.length() + air_accel_bonus)
	else:  # goes toward where the player is aiming, but deccelerates 
		return -dir_2D * p_vel.length() * AIR_BACK_DECCELERATE


# Movement when in air when going straight back
func _mvt_air_bw(p_vel: Vector2) -> Vector2:
	return p_vel * AIR_STANDARD_DECCELERATE


# Movement when in air and strafing
# FIXME : It works, but the vector values are a bit weird...
func _mvt_air_strafe(p_vel: Vector2, dir_2D: Vector2, delta: float) -> Vector2:
	if abs(p_vel.angle_to(dir_2D)) < PI / 1.5:  # No backward movement, Don't ask questions about the 1.5. By visualising the vectors, it stops at PI/4 for some reason...
		var r_dir_2D = dir_2D.rotated(-input_movement_vector.x * PI / 4)  # rotates the dir_2D by PI/4, to give a vector that is "on the side" of the character, where the velocity will be projected to compute add_speed
		var add_speed_vector = p_vel.project(r_dir_2D)
		return p_vel + add_speed_vector * delta * AIR_ADD_STRAFE_SPEED
	else:  # go backward like in _mvt_air_fw 
		var r_dir_2D = dir_2D.rotated(input_movement_vector.x * PI / 3)  # rotates the dir_2D by PI/4, to give a vector that is "in front" of the character, where the velocity will be projected to compute add_speed. I don't know either with then PI/3, it just works better that way
		return -r_dir_2D * p_vel.length() * AIR_BACK_DECCELERATE


# Movement when in air and swaying straight left/right
func _mvt_air_sway(dir_2D: Vector2, p_vel: Vector2, delta: float) -> Vector2:
	return p_vel.move_toward(
		dir_2D.rotated(AIR_SWAY_ANGLE_MINUS_ANGLE * -input_movement_vector.x) * p_vel.length(),
		delta * AIR_SWAY_SPEED
	)


# computes the horizontal velocity when on ground
func _compute_ground_hvel(p_vel: Vector2, delta: float) -> Vector2:
	if _slide:
		if not states.has("sliding"):
			self.rotate_object_local(Vector3(1, 0, 0), -PI / 4)
			rotation_helper.rotate_object_local(Vector3(1, 0, 0), PI / 4)
			# p_vel += p_vel.normalized() * SLIDE_SPEED_BONUS_GROUND
			states.append("sliding")
		return p_vel.move_toward(Vector2(dir.x, dir.z) * p_vel.length(), delta * SLIDE_STEER_POWER)
	else:
		return p_vel.linear_interpolate(
			Vector2(dir.x, dir.z) * GROUND_TARGET_SPEED, GROUND_ACCELERATION * delta
		)


##### SIGNAL MANAGEMENT #####
func remove_shooting_state():
	if states.has("shooting"):
		states.erase("shooting")


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
		var wall_fw = (wall_normal.cross(wall_up) * -rc_dir).normalized()  # Forward direction, where the player should translate to (perpendicular to wall_normal and wall_up)
		# Note : wall_normal, wall_up, wall_fw should give a (kind of) orthogonal basis
		DebugDraw.set_text("Wall direction : ", _RC_wall_direction)
		DebugDraw.set_text("is colliding : ", rc.is_colliding())
		DebugDraw.draw_line_3d(
			rc.get_collision_point(), rc.get_collision_point() + wall_normal, Color(1, 0, 0)
		)
		DebugDraw.set_text("wall normal", wall_normal)
		DebugDraw.draw_line_3d(
			rc.get_collision_point(), rc.get_collision_point() + wall_up, Color(0, 1, 0)
		)
		DebugDraw.set_text("wall up", wall_up)
		DebugDraw.draw_line_3d(
			rc.get_collision_point(), rc.get_collision_point() + wall_fw, Color(0, 0, 1)
		)
		DebugDraw.set_text("wall fw", wall_fw)
