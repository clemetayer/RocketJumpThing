extends Area
# Changes the global song animation to the one in parameters on triggered

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var properties setget set_properties


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if "collision_layer" in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if "collision_mask" in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if properties.has("animation") and body.is_in_group("player"):
		var song_instance = VariableManager.song.instance()
		song_instance.ANIMATION = properties.animation
		var effect = FilterEffectManager.new()
		effect.TIME = 1.0
		StandardSongManager.add_to_queue(song_instance, effect)
