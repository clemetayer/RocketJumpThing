shader_type spatial;
render_mode unshaded;

// var
uniform vec2 size = vec2(1.0);
uniform vec3 target_pos = vec3(0.0); // position of the target in the world
uniform vec4 color : hint_color = vec4(1.0,0.0,0.0,1.0);
uniform float max_tgt_dist = 150.0; // max distance from the target to make the shader transparent

// const
const float PI = 3.1415;
const float frag_amount = 0.1; // How big the hexagons will be
const float outside_epsilon = 0.3; // smoothstep epsilon for the outside of the polygon
const float inside_epsilon = 0.04; // smoothstep epsilon for the outside of the polygon
const float max_size = 0.7; // Max size variation (pulse)
const float min_size = 0.4; // Min size variation (pulse)
// const float intensity = 5.0; // light intensity // Useless because the shader is unshaded
const float size_vary_speed = 2.0; // "pulse" speed

float dist_from_tgt(vec3 wrld_vertex)
{
	return(
		sqrt(
			pow(wrld_vertex.x - target_pos.x,2) 
			+ pow(wrld_vertex.y - target_pos.y,2) 
			+ pow(wrld_vertex.z - target_pos.z,2) 
		)
	);
}

void fragment()
{
	// time init, just to make it slightly less boring
	float size_vary = (sin(TIME * size_vary_speed)/2.0) + 0.5;
	// uv init
	vec2 uv = fract(UV * frag_amount);
	uv.x = fract(uv.x * size.x);
	uv.y = fract(uv.y * size.y);
	vec2 c_uv = (uv - 0.5)*2.0; // centered UV
	// polygon drawing
	float a = atan(c_uv.x,c_uv.y)+PI;
	float r = 2.0*PI/6.0; // 6.0 = Hexagon 
	// Shaping function that modulate the distance
	float d = cos(floor(0.5 + a/r) * r - a) * length(c_uv);
	ALBEDO = color.rgb;
	ALPHA = (1.0 - smoothstep(max_size * size_vary - outside_epsilon, max_size + outside_epsilon, d)) - 
		(1.0 - smoothstep(min_size - inside_epsilon, min_size + inside_epsilon, d));
	// Distance from the target
	ALPHA *= (1.0 - smoothstep(0.0,max_tgt_dist,dist_from_tgt((CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz)));
	// EMISSION = ALBEDO * intensity; // Useless because the shader is unshaded
} 