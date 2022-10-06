extends Collidable
# An area, but for D E A T H


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


##### SIGNAL MANAGEMENT #####
func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


func _on_body_entered(body: Node):
	if FunctionUtils.is_player(body):  # REFACTOR : create a global check is player
		SignalManager.emit_respawn_player_on_last_cp()
