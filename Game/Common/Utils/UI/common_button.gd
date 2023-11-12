extends Button
class_name CommonButton
# a common button script, mostly for sounds

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	DebugUtils.log_connect(self,self,"pressed", "_on_button_pressed")
	DebugUtils.log_connect(self,self,"mouse_entered", "_on_button_hover")

##### SIGNAL MANAGEMENT #####
func _on_button_pressed() -> void:
	RuntimeUtils.play_button_clicked_sound()

func _on_button_hover() -> void:
	RuntimeUtils.play_button_hover_sound()