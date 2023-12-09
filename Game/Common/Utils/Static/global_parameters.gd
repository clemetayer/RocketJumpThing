extends Reference
class_name GlobalParameters
# Mostly variables and constants corresponding to parameters

##### CONSTANTS #####
#---- DEBUG -----
const TUTORIALS_ENABLED := false  # to avoid triggering tutorials when testing levels (it gets annoying, I know how to play dammit, I created it)
const INPUT_RECORDER_ENABLED := true # Since at the moment of writing, the input recorder is only supposed to be used for tutorial purposes
const DEBUG_DRAW_ENABLED := {
	"set_text": true, "draw_line_3d": false, "draw_ray_3d": false, "draw_box": false
}
const DEATHGRID_ENABLED := true  # especially usefull in the map building phase
