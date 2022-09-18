shader_type spatial;

//---- Other parameters ----
uniform float max_size = 0.1;
uniform float ss_e = 0.0; // smoothstep epsilon
uniform int number_of_squares = 10;
uniform vec4 back_color : hint_color;
uniform vec4 color_1 : hint_color;
uniform vec4 color_2 : hint_color;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

vec4 square_stroke(vec2 uv, vec2 pos, float fade, float size, float rand)
{
	float square = smoothstep(pos.x - ss_e, pos.x + ss_e, uv.x) 
		* smoothstep(uv.x - ss_e, uv.x + ss_e, pos.x + size) 
		* smoothstep(pos.y - ss_e, pos.y + ss_e, uv.y) 
		* smoothstep(uv.y - ss_e, uv.y + ss_e, pos.y + size);
	vec4 col = mix(color_1,color_2,rand) * square;
	col.a = fade;
	return col;
}

void fragment(){
	vec2 uv = UV;
	uv.x = fract(uv.x * 3.0);
	uv.y = fract(uv.y * 2.0);
	vec4 color = back_color;
	for(int i = 0; i < number_of_squares; i++){
		float rand_x = random(vec2(float(i)/float(number_of_squares)));
		float rand_y = random(vec2(float(i)/float(number_of_squares),0.0));
		float rand_size = random(vec2(float(i)/float(number_of_squares))) * max_size;
		float rand_fade_sin_offset = random(vec2(0.0,float(i)/float(number_of_squares))) * 50.0;
		vec2 pos = vec2(rand_x, rand_y);
		float fade_amount = (sin(TIME * 3.0 + rand_fade_sin_offset) / 2.0) + 0.5;
		vec4 square = square_stroke(uv,pos,fade_amount/3.0,rand_size,random(vec2(float(i),3.0)));
		color.rgb += square.rgb * square.a;
	}
	ALBEDO = color.rgb;
	EMISSION = ALBEDO * 10.0;
}
