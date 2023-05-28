shader_type canvas_item;
render_mode unshaded;

const vec2 ASCII_CHAR_RATIO = vec2(2.0,1.0);

uniform sampler2D ascii_char;
uniform float FRACT_SIZE = 10.0;

vec4 pixelate_texture(vec2 uv, sampler2D texture, vec2 fract_size) {
	vec2 step_uv = round(uv * fract_size)/fract_size;
	return texture(texture, step_uv);
}

vec4 color_to_ascii_char(sampler2D ascii_char_tex, vec2 ascii_char_ration, vec2 uv, vec4 color, float fract_size) {
	vec2 char_fract_size = ASCII_CHAR_RATIO * (fract_size * 2.0); // for some reason, removing the 2.0 creates half ascii chars
	vec2 fract_uv = fract(uv * char_fract_size);
	vec4 ascii_char_color = texture(ascii_char,fract_uv);
	return vec4(color.rgb,ascii_char_color.a * color.a);
}

void fragment(){
	vec4 pixelated_texture_color = pixelate_texture(UV,TEXTURE, ASCII_CHAR_RATIO * FRACT_SIZE);
	COLOR = color_to_ascii_char(ascii_char, ASCII_CHAR_RATIO, UV, pixelated_texture_color, FRACT_SIZE);
}
