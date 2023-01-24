extends StandardScene
# Script for the level 4

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED_STEPS := [15.0, 25.0]
const SONG_PART_2_PREFIX := "part_2"
const SONG_PART_2_0 := "part_2"
const SONG_PART_2_1 := "part_2_2"
const SONG_PART_2_2 := "part_2_3"


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.SPEED_UPDATED, "_on_SignalManager_speed_updated"
	)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_speed_updated(speed: float) -> void:
	if StandardSongManager.has_current() and not StandardSongManager.is_updating():
		var current_song: Song = StandardSongManager.get_current()
		if (
			current_song is SongAnimationPlayer
			and current_song.ANIMATION != null
			and current_song.ANIMATION.begins_with(SONG_PART_2_PREFIX)
		):
			if speed < SPEED_STEPS[0] and current_song.ANIMATION != SONG_PART_2_0:
				_change_song_anim(SONG_PART_2_0)
			elif (
				speed >= SPEED_STEPS[0]
				and speed < SPEED_STEPS[1]
				and current_song.ANIMATION != SONG_PART_2_1
			):
				_change_song_anim(SONG_PART_2_1)
			elif speed > SPEED_STEPS[1] and current_song.ANIMATION != SONG_PART_2_2:
				_change_song_anim(SONG_PART_2_2)
