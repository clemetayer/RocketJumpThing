extends KinematicBody
class_name Player
# Script for the player

"""
Notes : 
- Si on va vers l'avant avec une vitesse faible, on va doucement vers une vitesse max
- air :
	- si ni gauche, ni droite pressé (ou somme des 2 = 0):
		- Si dir dans le même sens que velocity (Différence d'angle > PI/2):
			- Velocity prend la direction de wishdir en gardant sa norme
		- Sinon:
			- On ralentit d'un certain facteur
	- sinon :
		- si à la fois avant/arrière + gauche/droite:
			- Si velocity dans le même sens que wishdir (différence d'angle < PI/2)
				- Strafe jump 
			- Sinon:
				- On ralentit d'un certain facteur en allant vers la direction souhaitée (légèrement, à peu près la même chose que pour le strafe) vers la direction souhaitée 
		- sinon :
			- Mouvement gauche/droite normal
	- si rien d'appuyé, on diminue légèrement la vélocité (note : touche pour conserver la vélocité dans ce cas ? Shift peut-être ?)
- sol :
	- slide:
		- plus ou moins pareil qu'en l'air, mais au sol, mais avec le strafe plus... brutal
		- boost si on saute pendant un slide
	- sinon:
		- on bouge normal quoi
TODO :
	- Ralentir en allant quand on presse la touche pour aller en dans l'autre sens
"""

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
#~~~~ MOVEMENT ~~~~~
#==== GLOBAL =====
const GRAVITY := -24.8  # Gravity applied to the player
const JUMP_POWER := 18  # Power applied when jumping
const FLOOR_POWER := -1  # Standard gravity power applied to the player when is on floor (to avoid gravity to keep decreasing on floor)
const MAX_SLOPE_ANGLE = 45  # Max slope angle where you stop sliding

#==== AIR =====
const AIR_TARGET_SPEED := 75  # Target acceleration when just pressing forward in the air
const AIR_ADD_STRAFE_SPEED := 100  # Speed that is added during a strafe
const AIR_BACK_DECCELERATE := 0.98  # Speed decceleration when pressing an opposite direction to the velocity
const AIR_STANDARD_DECCELERATE := 0.985  # Speed decceleration when not pressing anything
const AIR_ACCELERATION := 1.5  # Acceleration in air to get to the AIR_TARGET_SPEED
const AIR_STEER_STRAFE_BONUS_ANGLE := PI / 10  # "Stiffness" of the turn when air strafing

#==== GROUND =====
const GROUND_TARGET_SPEED := 50  # Ground target speed
const GROUND_ACCELERATION := 4.5  # Acceleration on the ground to get to GROUND_TARGET_SPEED

#~~~~~ PROJECTILES ~~~~~ 
const ROCKET_DELAY := 1.0  # Time before you can shoot another rocket
const ROCKET_SCENE_PATH := "res://Game/Common/MovementUtils/Rocket/Rocket.tscn"  # Path to the rocket scene

#---- EXPORTS -----
export (Dictionary) var PATHS = {"camera": NodePath("."), "rotation_helper": NodePath(".")}

#---- STANDARD -----
#==== PUBLIC ====
var mouse_sensitivity = 0.05  # mouse sensitivity
var states = []  # player current states
var input_movement_vector = Vector2()  # vector for the movement 
var vel := Vector3()  # velocity vector
var dir := Vector3()  # wished direction by the player
var current_speed := 0.0  # current speed of the player
var camera  # camera node
var rotation_helper  # rotation helper node

#==== PRIVATE ====
var _add_velocity_vector_queue := []  # queue to add the vector to the velocity on the next process (used to make external elements interact with the player velocity)
var _old_velocity := Vector3(0, 0, 0)  # keep in memory the old velocity, for the left-right only input for instance

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
#	DebugDraw.draw_line_3d(self.transform.origin, self.translation + dir, Color(0, 1, 1))
#	DebugDraw.draw_line_3d(
#		self.translation, self.transform.origin + Vector3(vel.x, 0, vel.z), Color(0, 1, 0)
#	)
#	DebugDraw.draw_line_3d(
#		self.transform.origin,
#		self.transform.origin + camera.get_global_transform().basis.x,
#		Color(1, 0, 0)
#	)
#	DebugDraw.draw_line_3d(
#		self.transform.origin,
#		self.transform.origin + camera.get_global_transform().basis.y,
#		Color(0, 1, 0)
#	)
#	DebugDraw.draw_line_3d(
#		self.transform.origin,
#		self.transform.origin + camera.get_global_transform().basis.z,
#		Color(0, 0, 1)
#	)
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
			vel.y += JUMP_POWER
		else:
			vel.y = FLOOR_POWER

	# Shooting
	if Input.is_action_pressed("action_shoot") and not states.has("shooting"):
		states.append("shooting")
		var rocket = load(ROCKET_SCENE_PATH).instance()
		rocket.START_POS = transform.origin
		rocket.DIRECTION = -cam_xform.basis.z
		rocket.UP_VECTOR = Vector3(0, 1, 0)
		get_parent().add_child(rocket)
		var _err = get_tree().create_timer(ROCKET_DELAY).connect(
			"timeout", self, "remove_shooting_state"
		)

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# process for the movement
func _process_movement(delta):
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


# updates the states
func _process_states():
	DebugDraw.set_text("states", states)
	if is_on_floor() and not states.has("in_air"):
		states.append("in_air")
	if current_speed != 0 and not states.has("moving"):
		states.append("moving")


# computes the horizontal velocity
func _compute_hvel(p_vel: Vector2, delta: float) -> Vector2:
	current_speed = p_vel.length()
	if is_on_floor():
		return _compute_ground_hvel(p_vel, delta)
	else:
		return _compute_air_hvel(p_vel, delta)


# computes the horizontal velocity when in air
func _compute_air_hvel(p_vel: Vector2, delta: float) -> Vector2:
	var ret_vel = Vector2()  # return vector
	var dir_2D = Vector2(dir.x, dir.z)
	if input_movement_vector.x == 0:  # no left/right input
		if input_movement_vector.y != 0:  # forward/backward input
			if abs(dir_2D.angle_to(p_vel)) <= PI / 2:  # keeps the same speed, but goes instantly toward what the player is aiming
				ret_vel = dir_2D * p_vel.length()
			else:  # goes toward where the player is aiming, but deccelerates 
				ret_vel = -dir_2D * p_vel.length() * AIR_BACK_DECCELERATE
		else:  # just keeps the same vector (no horizontal movement input)
			ret_vel = p_vel * AIR_STANDARD_DECCELERATE
	else:  # left/right input
		if input_movement_vector.y != 0:  # this is where you should gain a lot of speed, by "snaking" or strafing
			var add_speed = (
				clamp(abs(p_vel.angle_to(dir_2D) / (PI / 2)), 0, 1)
				* AIR_ADD_STRAFE_SPEED
			)
			ret_vel = (
				p_vel
				+ (
					dir_2D.rotated(input_movement_vector.x * AIR_STEER_STRAFE_BONUS_ANGLE)
					* add_speed
					* delta
				)
			)
		else:  # should move to the left/right without modifying the speed (and also goes towards the mouse vector)
			ret_vel = p_vel.rotated(
				(
					(PI / 2)
					* -input_movement_vector.x
					* delta
					* (1 / 2)
					* clamp(p_vel.angle_to(dir_2D) / PI, 0, 1)
				)
			)  # FIXME : velocity stops ???
	return ret_vel


# computes the horizontal velocity when on ground
func _compute_ground_hvel(p_vel: Vector2, delta: float) -> Vector2:
	return p_vel.linear_interpolate(
		Vector2(dir.x, dir.z) * GROUND_TARGET_SPEED, GROUND_ACCELERATION * delta
	)


##### SIGNAL MANAGEMENT #####
func remove_shooting_state():
	if states.has("shooting"):
		states.erase("shooting")
