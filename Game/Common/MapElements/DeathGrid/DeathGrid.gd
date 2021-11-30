extends Area
class_name DeathGrid

"""
- TODO : add a nice effect when getting close to the grid 
"""


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	connect("body_exited", self, "_on_body_exited")


##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_respawn_player_on_last_cp()
