extends StandardScene
# Root tutorial 3 scene script


func _on_KickTimer_timeout():
	SignalManager.emit_sequencer_step("kick")
