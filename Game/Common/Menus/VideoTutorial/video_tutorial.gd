extends Control
# Video tutorial script

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"escape_label": $"Label",
	"video_player": $"VideoPlayer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()

##### PUBLIC METHODS #####
func play_video(path : String) -> void:
	var stream = VideoStreamWebm.new()
	stream.set_file(path)
	onready_paths.video_player.stream = stream
	onready_paths.video_player.play()

func stop_video() -> void:
	onready_paths.video_player.stop()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, SignalManager.TRANSLATION_UPDATED, "_on_SignalManager_translation_updated")
	DebugUtils.log_connect(onready_paths.video_player, self, "finished", "_on_VideoPlayer_finished")

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_translation_updated() -> void:
	onready_paths.escape_label.text = tr(TranslationKeys.TUTORIAL_ESCAPE_TO_SKIP)

func _on_VideoPlayer_finished() -> void:
	MenuNavigator.exit_navigation()
