extends Collidable
# Area to check the speed before breaking the associated wall
# TODO : update entity

##### SIGNALS #####
signal trigger(parameters)

##### VARIABLES #####
#---- CONSTANTS -----
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_rocket_ui.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _ui_load := preload(UI_PATH)


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(self, self, "area_entered", "_on_breakable_area_rocket_area_entered")


# Called when the node enters the scene tree for the first time.
func _ready():
	var ui := _ui_load.instance()
	add_child(ui)
	var sprite := Sprite3D.new()
	if "text_direction" in properties:  # text is a texture here. this is a convenient word :)
		sprite.rotation_degrees = properties.text_direction
	sprite.scale = Vector3(15, 15, 1)
	add_child(sprite)
	if "scale" in properties:
		sprite.scale = properties.scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true


##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	.update_properties()


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_rocket_area_entered(area):
	if area is Rocket:
		emit_signal("trigger", {"position": area.transform.origin, "speed": area.SPEED})
		self.queue_free()
