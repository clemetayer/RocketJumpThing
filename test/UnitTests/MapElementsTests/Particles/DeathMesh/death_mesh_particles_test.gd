# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the death mesh particles (mostly not crashing)

##### VARIABLES #####
const death_mesh_particles_path := "res://Game/Common/MapElements/Particles/DeathMesh/death_mesh_particles.tscn"


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = death_mesh_particles_path
	.before()
