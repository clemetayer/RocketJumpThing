shader_type canvas_item;
render_mode unshaded;
// Inspired from : https://www.shadertoy.com/view/ltGSWD
// (But remade from scratch)

// background
uniform vec4 back_color1 : hint_color;
uniform vec4 back_color2 : hint_color;
uniform float back_cycle_speed;

// wave 1
uniform vec4 wave1_color : hint_color = vec4(1.0,1.0,1.0,1.0);
uniform float wave1_thick : hint_range(0.0,1.0) = 0.4;
uniform float wave1_up_sine_speed = 0.25;
uniform float wave1_up_sine_amplitude = 0.08;
uniform float wave1_down_sine_speed = 0.15;
uniform float wave1_down_sine_amplitude = 0.08;

// wave 2
uniform vec4 wave2_color : hint_color = vec4(1.0,1.0,1.0,1.0);
uniform float wave2_thick : hint_range(0.0,1.0) = 0.5;
uniform float wave2_up_sine_speed = 0.2;
uniform float wave2_up_sine_amplitude = 0.08;
uniform float wave2_down_sine_speed = 0.3;
uniform float wave2_down_sine_amplitude = 0.03;


const float PI = 3.14159265358979323846;

// Computes the background
vec4 background(vec2 uv, float t){
	return mix(back_color1,back_color2, uv.x*uv.y + sin(t * back_cycle_speed));
}

// Computes a first wave
vec3 wave1(vec2 uv, float t){
	float sine_up = sin(2.0 * PI * (uv.x + t * wave1_up_sine_speed)) * wave1_up_sine_amplitude;
	float sine_down = sin(2.0 * PI * (uv.x + t * wave1_down_sine_speed)) * wave1_down_sine_amplitude;
	float up_limit = (0.5 - wave1_thick/2.0) - sine_up; // up sine limit
	float down_limit = (0.5 + wave1_thick/2.0) - sine_down; // down sine limit
	float up_sine = smoothstep(uv.y-wave1_thick/2.0,uv.y,up_limit) - smoothstep(uv.y,uv.y + 0.02,up_limit);
	float down_sine = smoothstep(uv.y,uv.y + wave1_thick/2.0,down_limit) - smoothstep(uv.y - 0.02,uv.y,down_limit);
	vec3 color = wave1_color.rgb * (up_sine - down_sine);
	return color;
}

// Computes a second wave
vec3 wave2(vec2 uv, float t){
	float sine_up = sin(2.0 * PI * (uv.x + t * wave2_up_sine_speed)) * wave2_up_sine_amplitude;
	float sine_down = sin(2.0 * PI * (uv.x + t * wave2_down_sine_speed)) * wave2_down_sine_amplitude;
	float up_limit = (0.5 - wave2_thick/2.0) - sine_up; // up sine limit
	float down_limit = (0.5 + wave2_thick/2.0) - sine_down; // down sine limit
	float up_sine = smoothstep(uv.y-wave2_thick/2.0,uv.y,up_limit) - smoothstep(uv.y,uv.y + 0.02,up_limit);
	float down_sine = smoothstep(uv.y,uv.y + wave2_thick/2.0,down_limit) - smoothstep(uv.y - 0.02,uv.y,down_limit);
	vec3 color = wave2_color.rgb * (up_sine - down_sine);
	return color;
}

void fragment() {
//	vec3 color = wave1(UV,TIME);
	vec3 color = mix(background(UV,TIME).rgb,wave1(UV,TIME),0.25);
	color = mix(color,wave2(UV,TIME),0.25);
	COLOR = vec4(color,1.0);
}