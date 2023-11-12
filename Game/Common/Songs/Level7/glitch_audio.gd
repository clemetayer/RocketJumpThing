extends Node
# A special Node, to glitch the audio at the last part of the level 7

##### VARIABLES #####
#---- CONSTANTS -----
const GLITCH_SAMPLES := {
	"200ms":preload("res://Misc/Audio/BGM/Level7/Glitches/glitch_200ms.wav"),
	"500ms":preload("res://Misc/Audio/BGM/Level7/Glitches/glitch_500ms.wav"),
	"1s":preload("res://Misc/Audio/BGM/Level7/Glitches/glitch_1s.wav"),
	"3s":preload("res://Misc/Audio/BGM/Level7/Glitches/glitch_3s.wav")
}
const LEVEL_7_BGM_BUS_NAME := "Level7"
const LEVEL_7_GLITCH_BUS_NAME := "Level7Glitch"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"audio_stream_player":$"Glitch"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, SignalManager.GLITCH_AUDIO, "_on_SignalManager_glitch_audio")

func _play_glitch(sample_path : AudioStream) -> void:
	onready_paths.audio_stream_player.stream = sample_path
	AudioServer.set_bus_mute(AudioServer.get_bus_index(LEVEL_7_BGM_BUS_NAME),true)
	onready_paths.audio_stream_player.play()
	yield(onready_paths.audio_stream_player,"finished")
	AudioServer.set_bus_mute(AudioServer.get_bus_index(LEVEL_7_BGM_BUS_NAME),false)

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_glitch_audio(part : int) -> void:
	match(part):
		0:
			_play_glitch(GLITCH_SAMPLES["200ms"])
		1:
			_play_glitch(GLITCH_SAMPLES["500ms"])
		2:
			_play_glitch(GLITCH_SAMPLES["1s"])
		3:
			_play_glitch(GLITCH_SAMPLES["3s"])
