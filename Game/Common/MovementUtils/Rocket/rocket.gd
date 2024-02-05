extends Area
# A rocket, to rocket jump mostly

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED := 12.5  # travel speed of the rocket
const RAYCAST_DISTANCE := 12.5  # maximum distance to detect a floor
const RAYCAST_PLAN_EXPLODE_DISTANCE := 0.3125  # Distance from a floor where the explosion should be planned (since it's imminent), to be sure that is will explode (high speed makes collision weird)
#---- EXPORTS -----
export(Vector3) var START_POS = Vector3(0, 0, 0)
export(Vector3) var DIRECTION = Vector3(0, 0, 0)  # direction (normalized) where the rocket should travel
export(Vector3) var UP_VECTOR = Vector3(0, 1, 0)  # up vector

#==== PRIVATE ====
var _translate := false
var _expl_planned := false  # if the explosion has been already planned
var _speed := 0.0  # travel speed of the rocket # kept as a private variable in case I add something that makes the rocket speed vary
var _debug_rocket_explode := 0.0
var _target  # target sprite to be displayed on the floor/wall/whatever

#==== ONREADY ====
onready var onready_paths := {
	"trail_sound": $"TrailSound",
	"raycast": $"RayCast",
	"update_raycast_timer": $"UpdateRaycastTimer"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_target()
	_init_rocket()
	_play_rocket_sound()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if _translate:
		translate_object_local(Vector3(0, 0, 1) * _speed * delta)


##### PUBLIC METHODS #####
func remove() -> void:
	_remove_target()
	queue_free()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.update_raycast_timer, self, "timeout", "_on_UpdateRaycastTimer_timeout")

func _init_target() -> void:
	_target = RuntimeUtils.ROCKET_TARGET_SCENE.instance()


func _init_rocket() -> void:
	global_transform.origin = START_POS
	_speed = SPEED
	var target: Vector3 = START_POS - DIRECTION
	if FunctionUtils.check_in_epsilon(
		fmod((target - self.global_transform.origin).angle_to(UP_VECTOR), PI), 0, pow(10, -4)
	):  # vectors are aligned with y axis, do not use "look_at"
		if (target - self.global_transform.origin).y > 0:  # shoot straight down
			rotate_object_local(Vector3.RIGHT, PI / 2)
		else:  # shoot straight up
			rotate_object_local(Vector3.RIGHT, -PI / 2)
	else:  # vectors are not aligned, it is safe to use "look_at"
		look_at(START_POS - DIRECTION, UP_VECTOR)
	_translate = true


func _play_rocket_sound() -> void:
	onready_paths.trail_sound.play()


# checks the raycast distance from the closest "floor", to explode if needed
func _check_raycast_distance(raycast: RayCast) -> void:
	raycast.cast_to = Vector3(0, 0, 1) * RAYCAST_DISTANCE
	if raycast.is_colliding():
		var distance = _get_distance_to_collision(raycast)
		_update_target(raycast, distance)
	else:
		_remove_target()


# returns the distance from the rocket position to the collision point (using the normal)
func _get_distance_to_collision(raycast: RayCast) -> float:
	var col_point = raycast.get_collision_point()
	var normalized_traj = col_point.direction_to(self.transform.origin)
	var normalized_normal = col_point.direction_to(
		raycast.get_collision_point() + raycast.get_collision_normal()
	)
	var angle_to_normal = normalized_traj.angle_to(normalized_normal)
	var normal_vect = (
		raycast.get_collision_normal()
		* (cos(angle_to_normal) * self.transform.origin.distance_to(col_point))
	)
	DebugDraw.draw_line_3d(
		raycast.get_collision_point(), raycast.get_collision_point() + normal_vect, Color(1, 1, 1)
	)
	return normal_vect.length()


func _update_target(raycast: RayCast, distance: float) -> void:
	var scene_tree = ScenesManager.get_current()
	if is_instance_valid(_target):
		if not _target.is_inside_tree():
			scene_tree.add_child(_target)
		_target.set_pos(raycast.get_collision_point(), raycast.get_collision_normal())
		_target.update_scale(distance)


func _remove_target() -> void:
	if is_instance_valid(_target) and _target.is_inside_tree():
		ScenesManager.get_current().remove_child(_target)
		_target.queue_free()


# Explosion of the rocket
func _explode() -> void:
	_translate = false
	onready_paths.raycast.enabled = false
	_remove_target()
	var explosion = RuntimeUtils.ROCKET_EXPLOSION_SCENE.instance()
	explosion.EXPLOSION_POSITION = global_transform.origin
	ScenesManager.get_current().add_child(explosion)
	queue_free()


##### SIGNAL MANAGEMENT #####
func _on_Rocket_body_entered(body: Node):
	if not FunctionUtils.is_player(body):
		_expl_planned = false
		_explode()


# Unused for now
func _on_Rocket_area_entered(_area: Area):
	pass

func _on_UpdateRaycastTimer_timeout() -> void:
	_check_raycast_distance(onready_paths.raycast)