tool
extends Spatial


# Declare member variables here. Examples:
const SPHERE_SPEED = 4.0/10.0
const CUBE_SPEEDS = Vector3(PI/3.0,PI/2.0,PI)
const TIME_TICKS_DIVIDER = 1000.0
const ELECTRICITY_SCALE_MULTIPLIER = 40.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$OuterSphere.rotate(Vector3.UP, delta * SPHERE_SPEED)
	$Cube.rotate(Vector3.UP, sin(Time.get_ticks_msec() / TIME_TICKS_DIVIDER) * CUBE_SPEEDS.y * delta)
	$Cube.rotate(Vector3.FORWARD, CUBE_SPEEDS.z * delta)
	$Cube.rotate(Vector3.RIGHT, sin(Time.get_ticks_msec() / (TIME_TICKS_DIVIDER/2.0)) * CUBE_SPEEDS.x * delta)
#	$Electricity.mesh.radius = 1.0 * delta * (sin(Time.get_ticks_msec()/ (TIME_TICKS_DIVIDER/2.0))/2.0 + 0.5) * ELECTRICITY_SCALE_MULTIPLIER
#	$Electricity.mesh.height = 2.0 * delta * (sin(Time.get_ticks_msec()/ (TIME_TICKS_DIVIDER/2.0))/2.0 + 0.5) * ELECTRICITY_SCALE_MULTIPLIER
