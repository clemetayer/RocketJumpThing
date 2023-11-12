extends Node
# A node that is used to control a bus effect from the animation player 

##### VARIABLES #####
#---- EXPORTS -----
export(Resource) var AUDIO_EFFECT # the audio effect resource that needs to be modified
export(String) var EFFECT_NAME # name of the audio parameter to be modified
export(float) var EFFECT_VALUE # value of the effect


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if AUDIO_EFFECT != null and AUDIO_EFFECT is AudioEffect and EFFECT_NAME in AUDIO_EFFECT:
		AUDIO_EFFECT.set(EFFECT_NAME, EFFECT_VALUE)
