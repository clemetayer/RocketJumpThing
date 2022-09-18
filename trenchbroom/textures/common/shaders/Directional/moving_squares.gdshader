shader_type spatial;

//---- Other parameters ----
uniform float max_size = 0.05;
uniform float width = 0.01;
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

vec4 square_stroke(vec2 uv, float rand, vec2 pos)
{
	float outer_square = smoothstep(pos.x - ss_e, pos.x + ss_e, uv.x) * smoothstep(uv.x - ss_e, uv.x + ss_e, pos.x + max_size) * smoothstep(pos.y - ss_e, pos.y + ss_e, uv.y) * smoothstep(uv.y - ss_e, uv.y + ss_e, pos.y + max_size);
	float inner_square = smoothstep(pos.x + width - ss_e, pos.x + width + ss_e, uv.x) * smoothstep(uv.x - ss_e, uv.x + ss_e , pos.x + max_size - width) * smoothstep(pos.y + width - ss_e, pos.y + width + ss_e, uv.y) * smoothstep(uv.y - ss_e, uv.y + ss_e, pos.y + max_size - width);
	float stroke = outer_square - inner_square;
	return mix(color_1,color_2,rand) * stroke;
}

void fragment(){
	vec2 uv = UV;
	uv.x = fract(uv.x * 3.0);
	uv.y = fract(uv.y * 2.0);
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
	}
	ALBEDO = color.rgb;
}
