extends Spatial
# Main menu script


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	MenuNavigator.toggle_pause_enabled(false)
	MenuNavigator.show_main_menu()
