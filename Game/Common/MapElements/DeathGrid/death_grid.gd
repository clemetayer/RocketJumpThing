extends Area
class_name DeathGrid


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


#==== PRIVATE ====
func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.POSITION_UPDATED, "_on_player_position_updated"
	)


##### SIGNAL MANAGEMENT #####
func _on_player_position_updated(position: Vector3) -> void:
	for child in get_children():
		if child is MeshInstance:
			child.mesh.surface_get_material(0).set_shader_param("target_pos", position)


func _on_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		SignalManager.emit_respawn_player_on_last_cp()
		RuntimeUtils.play_death_sound()
