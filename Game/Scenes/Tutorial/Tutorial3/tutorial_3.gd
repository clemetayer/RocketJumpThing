tool
extends StandardScene
# Root tutorial 3 scene script

func _ready():
	var vp_tex = $AdditionalThings/SkyBox.get_texture()
	$WorldEnvironment.environment.background_sky.panorama = vp_tex


func _on_KickTimer_timeout():
	SignalManager.emit_sequencer_step("kick")
