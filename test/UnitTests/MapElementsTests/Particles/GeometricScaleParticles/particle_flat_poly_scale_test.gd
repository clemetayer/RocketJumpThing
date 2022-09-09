# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests that the particle flat poly scale does not crash

##### VARIABLES #####
const particle_path := "res://Game/Common/MapElements/Particles/GeometricScaleParticles/particle_flat_poly_scale.tscn"


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = particle_path
	.before()
