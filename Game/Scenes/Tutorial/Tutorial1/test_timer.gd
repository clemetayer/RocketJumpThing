extends Timer
# Some tests for signals


func _on_Timer_timeout():
	SignalManager.emit_sequencer_step("light_1")
