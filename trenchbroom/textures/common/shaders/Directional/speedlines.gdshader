// heavily inspired from https://godotshaders.com/shader/speedlines/
shader_type spatial;

//---- Other parameters ----
uniform sampler2D noise;
uniform vec4 material_color: hint_color;
uniform vec4 line_color_a: hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 line_color_b: hint_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float line_threshold = 0.6;
uniform float inverse_speed = 10.0;
uniform float line_length = 1000.0;
uniform float angle: hint_range(0.0, 360.0) = 0.0;
uniform float intensity: hint_range(0.0,16.0) = 4.0;


void fragment() {
	vec2 uv = vec2(UV.x * cos(radians(angle)) - UV.y * sin(radians(angle)), UV.x * sin(radians(angle)) + UV.y * cos(radians(angle)));
	vec4 noise_line = texture(noise, vec2(uv.x / line_length + TIME / inverse_speed, uv.y));
	if (noise_line.r < line_threshold){
		ALPHA = material_color.a;
		ALBEDO = material_color.rgb;
	} else {
		if(noise_line.g <= 0.72){
			ALBEDO = line_color_a.rgb;
		}
		else{
			ALBEDO = line_color_b.rgb;
		}
		EMISSION = ALBEDO * intensity;
	}
}