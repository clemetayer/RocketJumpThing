tool
extends Spatial

##### ENUMS #####
enum anim_enum { PART_0, PART_1, PART_2, PART_3, PART_4, PART_5 }

##### VARIABLES #####
#---- CONSTANTS -----
const SPHERE_SPEED := 4.0 / 10.0
const CUBE_SPEEDS := Vector3(PI / 3.0, PI / 2.0, PI)
const TIME_TICKS_DIVIDER := 1000.0
const ELECTRICITY_SCALE_MULTIPLIER := 40.0
const ANIM_LIST := ["part_0", "part_1", "part_2", "part_3", "part_4", "part_5"]

#---- STANDARD -----
#==== PRIVATE ====
var _anim_step: int = anim_enum.PART_0

#==== ONREADY ====
onready var onready_paths = {
	"outer_sphere": $OuterSphere,
	"cube": $Cube,
	"electricity_particles": $ElectricityParticles,
	"cube_particles": $CubeParticles,
	"animation_tree": $AnimationTree
}


##### PUBLIC METHODS #####
func next_anim() -> void:
	var state_machine = onready_paths.animation_tree["parameters/playback"]
	if state_machine != null and _anim_step < anim_enum.size():
		_anim_step += 1
		state_machine.travel(ANIM_LIST[_anim_step])


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	onready_paths.outer_sphere.rotate(Vector3.UP, delta * SPHERE_SPEED)
	onready_paths.cube.rotate(
		Vector3.UP, sin(Time.get_ticks_msec() / TIME_TICKS_DIVIDER) * CUBE_SPEEDS.y * delta
	)
	onready_paths.cube.rotate(Vector3.FORWARD, CUBE_SPEEDS.z * delta)
	onready_paths.cube.rotate(
		Vector3.RIGHT,
		sin(Time.get_ticks_msec() / (TIME_TICKS_DIVIDER / 2.0)) * CUBE_SPEEDS.x * delta
	)
