extends Node2D
# End game script


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Input.is_action_pressed(GlobalConstants.INPUT_CANCEL):
		load_main_menu()


##### PUBLIC METHODS #####
func load_main_menu() -> void:
	ScenesManager.load_main_menu()
