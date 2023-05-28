#tool
extends RichTextLabel
# A tool that transforms an image to ascii art

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const BITMAP_TRANSPARENCY_TRESHOLD = 0.5
const FILL_CHARACTER = "#"
const EMPTY_CHARACTER = "  "
const NEWLINE_CHARACTER = "\n"
const CHARACTER_SIZE = Vector2(5, 10)

#---- EXPORTS -----
export(bool) var MONOCHROME = true
export(Texture) var IMAGE
export(bool) var DEBUG_CONVERT = false setget , _get_debug_convert

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass


##### PUBLIC METHODS #####
# generates an ASCII text based on the image
func generate() -> void:
	if IMAGE != null:
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(IMAGE.get_data(), BITMAP_TRANSPARENCY_TRESHOLD)
		var ascii_str = ""
		for y_pos in range(0, bitmap.get_size().y - CHARACTER_SIZE.y, CHARACTER_SIZE.y):
			for x_pos in range(0, bitmap.get_size().x - CHARACTER_SIZE.x, CHARACTER_SIZE.x):
				var is_full = get_is_part_full(bitmap, Vector2(x_pos, y_pos))
				ascii_str += FILL_CHARACTER if is_full else EMPTY_CHARACTER
			ascii_str += NEWLINE_CHARACTER
		bbcode_text = ascii_str


##### PROTECTED METHODS #####
func get_is_part_full(bitmap: BitMap, position: Vector2) -> bool:
	var true_cnt = 0
	for part_y_pos in range(0, CHARACTER_SIZE.y):
		for part_x_pos in range(0, CHARACTER_SIZE.x):
			if bitmap.get_bit(position + Vector2(part_x_pos, part_y_pos)):
				true_cnt += 1
	return true_cnt >= (CHARACTER_SIZE.x * CHARACTER_SIZE.y / 2)


func _get_debug_convert() -> bool:
	DEBUG_CONVERT = false
	if Engine.editor_hint:
		generate()
	return DEBUG_CONVERT
