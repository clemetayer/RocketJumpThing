extends Collidable
# An area, but for D E A T H


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		SignalManager.emit_respawn_player_on_last_cp()
