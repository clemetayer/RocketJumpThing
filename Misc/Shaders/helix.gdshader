shader_type spatial;

const float PI = 3.1415;

uniform vec4 color1 : hint_color = vec4(1.0,0.0,1.0,1.0);
uniform vec4 color2 : hint_color = vec4(1.0,1.0,0.0,1.0);
uniform float cylinder_height = 1.0;
uniform int number_of_lines = 3;
uniform float line_thickness = 0.1;
uniform float spin_speed = 0.5;
uniform float light_intensity = 1.5;

void fragment(){
	vec2 uv = UV;
	//uv.x = fract(uv.x * 3.0);
	//uv.y = fract(uv.y * 2.0);
	uv.y = fract(uv.y * cylinder_height);
	ALPHA = smoothstep(uv.y - line_thickness, uv.y, mod((uv.x + TIME /(1.0/spin_speed)) * float(number_of_lines),1.0)) 
		- smoothstep(uv.y, uv.y + line_thickness, mod((uv.x + TIME /(1.0/spin_speed)) * float(number_of_lines),1.0));
//	if(
//		mod((uv.x + TIME/(1.0/spin_speed)) * float(number_of_lines),1.0) < (uv.y + line_thickness) && 
//		mod((uv.x + TIME/(1.0/spin_speed)) * float(number_of_lines),1.0) > uv.y){
//		ALPHA = 1.0;
//	}
//	else{
//		ALPHA = 0.0;
//	}
	ALBEDO = mix(color1,color2,uv.y).rgb;
	EMISSION = ALBEDO * light_intensity;
}

//void light() {
//	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * ALBEDO * 50.0;
//}