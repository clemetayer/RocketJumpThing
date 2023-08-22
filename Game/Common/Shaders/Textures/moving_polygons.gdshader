// Kept this one too, smoothstep is fun
shader_type spatial;

uniform float max_size = 0.05;
uniform float width = 0.01;
uniform float size_divider = 1.0;
uniform float intensity = 1.0;
uniform float ss_e = 0.1; // smoothstep epsilon
uniform int number_of_squares = 10;
uniform float max_velocity = 1.0;
uniform float min_velocity = 0.1;
uniform bool left_to_right = true;
uniform vec4 back_color : hint_color;
uniform vec4 color_1 : hint_color;
uniform vec4 color_2 : hint_color;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float smoothstep_interval(float point, float pos_1, float pos_2){
	return smoothstep(pos_1 - ss_e, pos_1 + ss_e, point) - smoothstep(pos_2 - ss_e, pos_2 + ss_e, point);
}

float square_stroke_outer(vec2 uv, float rand, vec2 pos){
	float square = smoothstep_interval(uv.x,pos.x, pos.x + max_size) * smoothstep_interval(uv.y,pos.y, pos.y + max_size);
	if(pos.x + max_size >= 1.0){
		square += smoothstep_interval(uv.x, 0.0, mod(pos.x + max_size,1.0)) * smoothstep_interval(uv.y, pos.y, pos.y + max_size);
	}
	if(pos.y + max_size >= 1.0){
		square += smoothstep_interval(uv.x, pos.x, pos.x + max_size) * smoothstep_interval(uv.y, 0.0, mod(pos.y + max_size,1.0));
	}
	return square;
}

float square_stroke_inner(vec2 uv, float rand, vec2 pos){
	float square = smoothstep_interval(uv.x, pos.x + width, pos.x + max_size - width) * smoothstep_interval(uv.y, pos.y + width, pos.y + max_size - width);
	if(pos.x + max_size - width >= 1.0){
		square += smoothstep_interval(uv.x, 0.0, mod(pos.x + max_size - width,1.0)) * smoothstep_interval(uv.y, pos.y + width, pos.y + max_size - width);
	}
	if(pos.y + max_size - width >= 1.0){
		square += smoothstep_interval(uv.x, pos.x + width, pos.x + max_size - width) * smoothstep_interval(uv.y, 0.0, mod(pos.y + max_size - width,1.0));
	}
	return square;
}

vec4 square_stroke(vec2 uv, float rand, vec2 pos)
{
	float stroke = square_stroke_outer(uv,rand,pos) - square_stroke_inner(uv, rand, pos);
	return mix(color_1,color_2,rand) * stroke;
}

void fragment(){
	vec2 uv = UV;
	uv.x = fract(uv.x * (3.0/size_divider));
	uv.y = fract(uv.y * (2.0/size_divider));
	vec4 color = back_color;
	float left_to_right_val = 1.0;
	if(!left_to_right)
		left_to_right_val = -1.0;
	for(int i = 0; i < number_of_squares; i++){
		float rand_x = random(vec2(float(i)/float(number_of_squares)));
		float rand_y = random(vec2(float(i)/float(number_of_squares),0.0));
		float rand_vel = max(min_velocity,random(vec2(0.0,float(i)/float(number_of_squares))) * max_velocity);
		vec2 pos = vec2(0);
		pos.x = mod(TIME * rand_vel * left_to_right_val, 1.0) ;
		pos.y = rand_y;
		vec4 square = square_stroke(uv,rand_x, pos);
		color += square;
		EMISSION += color.rgb * intensity;
	}
	ALBEDO = color.rgb;
}
