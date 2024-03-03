extends Song
class_name SongAnimationPlayer
# A song implementation using the AnimationPlayer

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum bus_effects { filter }  # effect indexes in a bus

##### VARIABLES #####
#---- EXPORTS -----
export(NodePath) var ANIMATION_PLAYER
export(String) var SONG_SEND_TO = "Master"  # where the song bus should send
export(String) var ANIMATION  # Animation that should play
export(bool) var ALLOW_RECURSIVE_INIT = false  # If it should enable the search for AudioStream in recursive children nodes on init (can be usefull for organisation purposes)
export(Dictionary) var TRACK_CUSTOM_EFFECTS = {}  # Custom buses for tracks. Should be like {"track_name":[AudioEffect]}. Usefull to handle loops with reverbs or delay
export(float) var SLIDE_FX_FILTER_CUTOFF # Lowpass frequency filter for the slide bus

#---- STANDARD -----
#==== PRIVATE ====
var _tracks: Dictionary = {}  # track infos
var _update_track_infos := {"animation": "", "fade_out": []}
var _buses_cleared := true  # if the buses have been cleared or not


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	DebugUtils.log_stacktrace(
		"SongAnimationPlayer - Playing : %s with animation %s" % [name, ANIMATION], DebugUtils.LOG_LEVEL.debug
	)
	DebugUtils.log_connect(
		get_node(ANIMATION_PLAYER), self, "animation_started", "_on_animation_started"
	)
	_init_tracks()
	_init_buses()


# COMMENT IF YOU DON'T CHANGE Engine.time_scale
func _process(_delta):
	if Input.is_action_just_pressed("print_buses_status"):
		Logger.debug("============= printing buses =============")
		_print_buses()
		_print_track_infos()
	var anim_player = get_node(ANIMATION_PLAYER)
	if anim_player.is_playing():
		anim_player.playback_speed = 1.0 / Engine.time_scale  # HACK : when using a slowmotion effect, to avoid having the animation be slowed down too
	set_slide_fx_filter_cutoff(SLIDE_FX_FILTER_CUTOFF)

##### PUBLIC METHODS #####
# plays the song, returns an array to give to the EffectManager as a parameter
func play() -> Array:
	if _buses_cleared:
		_init_buses()
	get_node(ANIMATION_PLAYER).play(ANIMATION)
	return _get_track_effect_array(name, true)


# stops the song, returns an array to give to  the EffectManager as a parameter
func stop() -> Array:
	if _buses_cleared:
		_init_buses()
	if (
		get_parent() != null
		and not get_parent().is_connected("effect_done", self, "_on_parent_effect_done")
	):
		var _err = get_parent().connect("effect_done", self, "_on_parent_effect_done")
	if not _update_track_infos.fade_out.has(name):
		_update_track_infos.fade_out.push_back(name)  # name just means to stop all tracks, setups the stop of the song
	return _get_track_effect_array(name, false)


func update(song: Song) -> Array:
	var effect_array := []
	var stop_array := []
	if _buses_cleared:
		_init_buses()
	if ANIMATION != song.ANIMATION and get_node(ANIMATION_PLAYER).has_animation(song.ANIMATION):
		DebugUtils.log_stacktrace(
			"Song animation player - Updating current from %s to %s" % [ANIMATION, song.ANIMATION], DebugUtils.LOG_LEVEL.debug
		)
		var common_track_name = _get_same_track(song.ANIMATION)
		var animation_time: float
		var time_tracks: Dictionary
		if common_track_name != null:  # has a common track, base the other tracks on this one for the transition
			animation_time = _get_animation_time_from_track_time(song.ANIMATION, common_track_name)  # global time in the animation, depending on the common track
			time_tracks = _get_track_play_times(song.ANIMATION, animation_time)  # play time for each track on new animation
		else:
			var anim_player := get_node(ANIMATION_PLAYER)
			animation_time = fmod(
				anim_player.current_animation_position,
				anim_player.get_animation(song.ANIMATION).length
			)
			time_tracks = _get_track_play_times(song.ANIMATION, animation_time)  # play time for each track on new animation
		for track in _tracks:
			if track != name:  # not the root
				if (
					_tracks[track].playing_in_animation.has(ANIMATION)
					and not _tracks[track].playing_in_animation.has(song.ANIMATION)
				):  # current track playing should fade out
					effect_array.append_array(_get_track_effect_array(track, false))
					stop_array.append(track)
					_remove_track_from_stop_queue(track)
				elif (
					not _tracks[track].playing_in_animation.has(ANIMATION)
					and _tracks[track].playing_in_animation.has(song.ANIMATION)
				):  # new track should fade in (even if it is not currently playing)
					effect_array.append_array(_get_track_effect_array(track, true))
					if time_tracks.has(track):  # if not stopped, play the sound immediately at the correct position
						get_node(_tracks[track].path).play(time_tracks[track])
		if (
			get_parent() != null
			and not get_parent().is_connected("effect_done", self, "_on_parent_effect_done")
		):
			var _err = get_parent().connect("effect_done", self, "_on_parent_effect_done")
		_update_track_infos.animation = song.ANIMATION
		_update_track_infos.fade_out.push_back(stop_array)
	return effect_array


# links to the effects that can be triggered in "neutral" position (for example, same song, but lower the volume slowly on pause), depending on whatever is specified in parameters, returns an array to give to the EffectManager as a parameter
# parameters a dictionary of tracks you want to apply an effect (might also include root song, by just leaving the name of the song), with fade in/out
# dictionary should look like this : {track1 : {fade_in : bool}, track2 : {fade_in : bool}}
func get_neutral_effect_data(params: Dictionary) -> Array:
	var effect_array = []
	if _buses_cleared:
		_init_buses()
	for param in params.keys():
		if _tracks.has(param):
			effect_array.append_array(_get_track_effect_array(param, params[param].fade_in))
	return effect_array


# updates the volume of all the buses, according to their values in _tracks
# percents is the tween completion percentage, both to make the tween recognize this, and for debug purposes
func update_volumes(_percents: float):
	for track in _tracks.keys():
		if (
			AudioServer.get_bus_index(_tracks[track].bus) != null
			and AudioServer.get_bus_index(_tracks[track].bus) != -1
		):
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index(_tracks[track].bus), _tracks[track].volume
			)


# Triggers a specific step for the step sequencer in the SignalManager
func step_sequencer_emit_step(name: String) -> void:
	SignalManager.emit_sequencer_step(name)

func set_slide_fx_filter_cutoff(cutoff : float) -> void:
	var filter : AudioEffectFilter = AudioServer.get_bus_effect(
		AudioServer.get_bus_index(GlobalConstants.SLIDE_FX_BUS),
		0
	)
	filter.cutoff_hz = cutoff

##### PROTECTED METHODS #####
# inits the tracks infos
func _init_tracks():
	for child in get_children():
		var _unused = _init_track(child)  # inits the tracks in (at least) the root
	# special case of the song itself
	if not _tracks.has(name):
		_tracks[name] = {"bus": "", "volume": 0.0}
	_print_track_infos()


# inits a track recursively.
func _init_track(child: Node) -> Array:
	var elements = []
	if child is AudioStreamPlayer:
		elements.append(child.name)
		if not _tracks.has(child.name):
			_tracks[child.name] = {
				"bus": "", "path": get_path_to(child), "volume": 0.0, "playing_in_animation": []
			}
		for anim_name in get_node(ANIMATION_PLAYER).get_animation_list():
			var anim: Animation = get_node(ANIMATION_PLAYER).get_animation(anim_name)
			for track_idx in range(anim.get_track_count()):
				if (
					get_node(anim.track_get_path(track_idx)).name == child.name
					and not _tracks[child.name].playing_in_animation.has(anim_name)
				):
					_tracks[child.name].playing_in_animation.append(anim_name)
		if child.get_child_count() > 0 and ALLOW_RECURSIVE_INIT:  # search recursively in the children of the node
			for rec_child in child.get_children():
				elements.append_array(_init_track(rec_child))
	elif child.get_child_count() > 0 and ALLOW_RECURSIVE_INIT:  # search recursively in the children of the node
		for rec_child in child.get_children():
			elements.append_array(_init_track(rec_child))
	return elements


# initialises the buses for the song
func _init_buses():
	# Inits the root bus
	_create_bus(name, SONG_SEND_TO)
	_tracks[name].bus = name
	# inits the track buses
	for track_name in _tracks.keys():
		if track_name != name:  # not root of the song
			_create_bus("%s:%s" % [name, track_name], name)
			_tracks[track_name].bus = "%s:%s" % [name, track_name]
			get_node(_tracks[track_name].path).bus = "%s:%s" % [name, track_name]
	_buses_cleared = false
	_print_buses()


# clear the buses used in this song
func _clear_buses():
	for track in _tracks.keys():
		if AudioServer.get_bus_index(_tracks[track].bus) != -1:
			AudioServer.remove_bus(AudioServer.get_bus_index(_tracks[track].bus))
		else:
			DebugUtils.log_stacktrace("Bus not found : %s" % _tracks[track].bus, DebugUtils.LOG_LEVEL.debug)
	_buses_cleared = true


# Creates a bus with a specific name
# WARNING : If the bus already exists
func _create_bus(name: String, send_to: String):
	_create_default_bus(name, send_to)
	var track_name := name.split(":")[name.split(":").size() - 1]  # track name is the last element of the bus name splitted by ':' (<song>:<track>)
	# Adds the custom track effects
	if TRACK_CUSTOM_EFFECTS.has(track_name):
		for effect_idx in range(TRACK_CUSTOM_EFFECTS[track_name].size()):
			AudioServer.add_bus_effect(
				AudioServer.get_bus_index(name),
				TRACK_CUSTOM_EFFECTS[track_name][effect_idx].duplicate()
			)


# Creates a default bus, with default effects for transitions
func _create_default_bus(name: String, send_to: String):
	# removes the bus if it already exists
	if AudioServer.get_bus_index(name) != -1:
		AudioServer.remove_bus(AudioServer.get_bus_index(name))
	# initializes the bus
	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.bus_count - 1, name)
	AudioServer.set_bus_send(AudioServer.get_bus_index(name), send_to)
	# initializes the filter
	var filter = AudioEffectFilter.new()
	filter.cutoff_hz = 20000
	AudioServer.add_bus_effect(AudioServer.get_bus_index(name), filter, bus_effects.filter)


# returns an array of effects that can be applied to a track
func _get_track_effect_array(track_name: String, fade_in: bool):
	return [
		# Volume
		{
			"object": self,
			"interpolate_value": "%s:%s:%s" % ["_tracks", track_name, "volume"],
			"interpolate_type": "property",
			"type": "volume",
			"fade_in": fade_in
		},
		{
			"object": self,
			"interpolate_value": "update_volumes",
			"interpolate_type": "method",
			"type": "volume",
			"fade_in": fade_in
		},
		# Filter
		{
			"object":
			AudioServer.get_bus_effect(
				AudioServer.get_bus_index(_tracks[track_name].bus), bus_effects.filter
			),
			"interpolate_value": "cutoff_hz",
			"interpolate_type": "property",
			"type": "filter",
			"fade_in": fade_in
		}
	]


# returns the first common track playing in new song and current song, or null if they have no common tracks
func _get_same_track(new_animation: String):
	for track_name in _tracks:
		if track_name != name:  # not the root
			var track = _tracks[track_name]
			if (
				ANIMATION in track.playing_in_animation
				and new_animation in track.playing_in_animation  # if the track is both in the new and old animation
				and get_node(track.path).playing
			):  # and if the track is currently playing, that is a "coherent" link
				return track_name
	return null


# returns the animation time where the track matches the play_time
func _get_animation_time_from_track_time(animation: String, track: String) -> float:
	var anim: Animation = get_node(ANIMATION_PLAYER).get_animation(animation)
	for track_idx in range(anim.get_track_count()):
		if (
			get_node(anim.track_get_path(track_idx)) is AudioStreamPlayer
			and get_node(anim.track_get_path(track_idx)).name == track
		):  # audio track (idk, maybe there will be some other track types), and this is the common track
			var property_name := ""
			if anim.track_get_path(track_idx).get_subname_count() > 0:
				property_name = anim.track_get_path(track_idx).get_subname(
					anim.track_get_path(track_idx).get_subname_count() - 1
				)  # just gets the last property
			var key_idx = anim.track_find_key(track_idx, 0.0, false)  # closest key to start
			if (
				(
					property_name == "playing"
					or anim.track_get_type(track_idx) == Animation.TYPE_AUDIO
				)
				and anim.track_get_key_value(track_idx, key_idx)
			):  # value of the key is playing == true or is an audio key and track actually exists
				return (
					anim.track_get_key_time(track_idx, key_idx)
					+ get_node(_tracks[track].path).get_playback_position()
				)  # usually, the animation length is at least the length of the track (otherwise, just use modulo, but that would probably give weird results)
	DebugUtils.log_stacktrace("No animation time that matches the play_time found", DebugUtils.LOG_LEVEL.debug)
	return 0.0 


# returns the play times of each track, depending on the position of the animation
# if a track is not currently playing, it won't be in the return value
func _get_track_play_times(anim_name: String, anim_time: float) -> Dictionary:
	var anim: Animation = get_node(ANIMATION_PLAYER).get_animation(anim_name)
	var play_times := {}
	for track_idx in range(anim.get_track_count()):
		var _type = anim.track_get_type(track_idx)
		if get_node(anim.track_get_path(track_idx)) is AudioStreamPlayer:  # audio track (idk, maybe there will be some other track types)
			var track_name = get_node(anim.track_get_path(track_idx)).name
			var property_name := ""
			if anim.track_get_path(track_idx).get_subname_count() > 0:
				property_name = anim.track_get_path(track_idx).get_subname(
					anim.track_get_path(track_idx).get_subname_count() - 1
				)  # just gets the last property
			var key_idx = anim.track_find_key(track_idx, anim_time, false)  # closest key to animation time
			if (
				(
					property_name == "playing"
					or anim.track_get_type(track_idx) == Animation.TYPE_AUDIO
				)
				and anim.track_get_key_value(track_idx, key_idx)
			):  # value of the key is playing == true or is an audio key
				play_times[track_name] = anim_time - anim.track_get_key_time(track_idx, key_idx)
	return play_times


# removes a track from the stop queue
# Note : even if an element is empty, it should stay in the queue.
func _remove_track_from_stop_queue(track: String):
	for stop_idx in range(_update_track_infos.fade_out.size()):
		if _update_track_infos.fade_out[stop_idx].has(name):  # cancels the stop of the entire song
			for track in _tracks.keys():
				if track == name:
					_update_track_infos.fade_out[stop_idx].erase(name)
				else:
					_update_track_infos.fade_out[stop_idx].append(track)
			_update_track_infos.fade_out[stop_idx].erase(name)
		elif _update_track_infos.fade_out[stop_idx].has(track):
			_update_track_infos.fade_out[stop_idx].erase(track)


# resets a bus
func _reset_bus(name: String) -> void:
	var bus_idx := AudioServer.get_bus_index(name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, 0.0)
		AudioServer.get_bus_effect(bus_idx, bus_effects.filter).cutoff_hz = 20000


##### SIGNAL MANAGEMENT #####
func _on_parent_effect_done() -> void:
	if ANIMATION != _update_track_infos.animation:
		var common_track_name = _get_same_track(_update_track_infos.animation)
		var animation_time := 0.0
		if common_track_name != null:
			animation_time = _get_animation_time_from_track_time(
				_update_track_infos.animation, common_track_name
			)  # global time in the animation, depending on the common track
			if _update_track_infos.fade_out.size() > 0:
				var to_stop: Array = _update_track_infos.fade_out.pop_front()
				if to_stop.has(name):  # stop all the tracks
					for track in _tracks.keys():
						if track != name:
							_reset_bus(_tracks[track].bus)
							_tracks[track].volume = 0.0
					_reset_bus(_tracks[name].bus)  # Resets the global song bus
					_tracks[name].volume = 0.0
				else:
					for track in to_stop:
						_reset_bus(_tracks[track].bus)
						_tracks[track].volume = 0.0
		else:
			DebugUtils.log_stacktrace(
				"No common track between %s and %s" % [ANIMATION, _update_track_infos.animation], DebugUtils.LOG_LEVEL.warn
			)
			var anim_player := get_node(ANIMATION_PLAYER)
			# new animation time = old animation time modulo total new animation time
			if anim_player.has_animation(_update_track_infos.animation):
				animation_time = fmod(
					anim_player.current_animation_position,
					anim_player.get_animation(_update_track_infos.animation).length
				)
		# sets the infos of the new song
		ANIMATION = _update_track_infos.animation
		get_node(ANIMATION_PLAYER).play(_update_track_infos.animation)
		get_node(ANIMATION_PLAYER).seek(animation_time)
	if _recur_check_clear_buses(self):
		_clear_buses()


# recursively checks the nodes for audio stream players before clear buses
func _recur_check_clear_buses(node: Node) -> bool:
	var children := node.get_children()
	var should_clear_buses := true
	for child in children:
		if child is AudioStreamPlayer and child.playing:  # not everything is stopped
			should_clear_buses = false
		else:
			should_clear_buses = should_clear_buses and _recur_check_clear_buses(child)
	return should_clear_buses


# Keeps track of the AnimationPlayer's automatic transitions
func _on_animation_started(name: String) -> void:
	ANIMATION = name  # forces the current animation to be the real one


##### DEBUG #####
# prints the current
func _print_buses():
	for bus_idx in AudioServer.bus_count:
		var bus_effects = []
		for effect_idx in AudioServer.get_bus_effect_count(bus_idx):
			var effect = AudioServer.get_bus_effect(bus_idx, effect_idx)
			if effect is AudioEffectFilter:
				bus_effects.append({"effect":"filter","cutoff_hz":effect.cutoff_hz})
			elif effect is AudioEffectCompressor:
				bus_effects.append({"effect":"compressor", "threshold":effect.threshold, "ratio":effect.ratio, "gain": effect.gain})
			elif effect is AudioEffectDelay:
				bus_effects.append({"effect":"delay"})
			elif effect is AudioEffectReverb:
				bus_effects.append({"effect":"reverb", "room_size":effect.room_size})

		DebugUtils.log_stacktrace(
			"bus N°%d : %s, has effects : %s and sends to %s. Volume is %d db. is mute = %s" % [
				bus_idx,
				AudioServer.get_bus_name(bus_idx),
				bus_effects,
				AudioServer.get_bus_send(bus_idx),
				AudioServer.get_bus_volume_db(bus_idx),
				AudioServer.is_bus_mute(bus_idx)
			], DebugUtils.LOG_LEVEL.debug
		)

# prints the track infos
func _print_track_infos():
	DebugUtils.log_stacktrace(
		"%s" % _tracks, DebugUtils.LOG_LEVEL.debug
	)
