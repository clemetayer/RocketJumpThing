tool
extends RichTextLabel
# Creates an ASCII art version of the image in parameters
# make sure to use monospaced fonts
# Takes some time to compute, that's why there is a "Compute" export var associated to the "_compute" method. The result should be static anyways
# Might be improved with threads, but unnecessary if this is a static image (And for dynamic images, shaders might be a better option honestly)

##### VARIABLES #####
#---- CONSTANTS -----
const ALPHA_CHAR_STR := " .oIO#" # determines which character to choose depending on the alpha of the image

#---- EXPORTS -----
export(Texture) var IMAGE
export(bool) var COMPUTE = false setget _set_compute
export(Vector2) var CHAR_SIZE := Vector2(10, 20)  # the size of a character in pixels


##### PROTECTED METHODS #####
func _set_compute(compute : bool) -> void:
	if Engine.editor_hint:
		set_bbcode(_convert_to_BBCode(IMAGE))
		compute = false
		COMPUTE = compute

func _convert_to_BBCode(texture : Texture) -> String:
	var image = texture.get_data()
	var ret_str = ""
	for row_idx in range(int(image.get_height()/CHAR_SIZE.y)):
		for col_idx in range(int(image.get_width()/CHAR_SIZE.x)):
			var rect = Rect2(col_idx * CHAR_SIZE.x, row_idx * CHAR_SIZE.y, CHAR_SIZE.x, CHAR_SIZE.y)
			var avg_col = _get_image_average_color(image.get_rect(rect))
			var char_at = _get_char_from_alpha(avg_col.a)
			if(avg_col.a > 0.0):
				ret_str += TextUtils.BBCode_color_text(char_at, "#" + avg_col.to_html(false))
			else:
				ret_str += char_at
		ret_str += "\n"
	return ret_str

func _get_image_average_color(image : Image) -> Color:
	var sum_pixels = [0,0,0,0]
	for row_idx in range(int(image.get_height())):
		for col_idx in range(int(image.get_width())):
			image.lock()
			var color = image.get_pixel(col_idx, row_idx)
			image.unlock()
			sum_pixels[0] += color.r
			sum_pixels[1] += color.g
			sum_pixels[2] += color.b
			sum_pixels[3] += color.a
	var number_of_pixels = image.get_height() * image.get_width()
	return Color(sum_pixels[0]/number_of_pixels, sum_pixels[1]/number_of_pixels, sum_pixels[2]/number_of_pixels, sum_pixels[3]/number_of_pixels)

# Alpha in percents
func _get_char_from_alpha(alpha : float) -> String:
	return ALPHA_CHAR_STR[int(alpha * (ALPHA_CHAR_STR.length() - 1))]

##### SIGNAL MANAGEMENT #####
