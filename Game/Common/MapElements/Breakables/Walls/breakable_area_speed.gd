extends Collidable
# Area to check the speed before breaking the associated wall
# TODO : update entity

##### SIGNALS #####
signal trigger

##### VARIABLES #####
#---- CONSTANTS -----
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_speed_ui.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _treshold := 100.0  # treshold speed for the wall to break (greater or equal)
var _ui_load := preload(UI_PATH)

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if connect("body_entered", self, "_on_breakable_area_speed_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_breakable_area_speed_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)

# Called when the node enters the scene tree for the first time.
func _ready():
	if 'treshold' in properties:
		self._treshold = properties.treshold
	var ui := _ui_load.instance()
	ui.SPEED = _treshold
	add_child(ui)
	var sprite := Sprite3D.new()
	if 'text_direction' in properties:
		sprite.rotation_degrees = properties.text_direction
	sprite.scale = Vector3(15,15,1)
	add_child(sprite)
	if 'scale' in properties:
		sprite.scale = properties.scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true
	

##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	.update_properties()

##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_body_entered(body):
	if body.is_in_group("player") and body.current_speed >= _treshold:
		emit_signal("trigger")
		self.queue_free()
