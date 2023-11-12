extends Slider
class_name CommonSlider
# a common slider script, mostly for sounds

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	DebugUtils.log_connect(self,self,"value_changed", "_on_slider_changed")

##### SIGNAL MANAGEMENT #####
func _on_slider_changed(_value : float) -> void:
	RuntimeUtils.play_slider_moved_sound()