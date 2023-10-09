extends Particles
# Short script to make the particles """follow""" the player, to avoid drawing unnecessary particles


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	var player = ScenesManager.get_current().get_player()
	if player != null:
		global_transform.origin = player.global_transform.origin
