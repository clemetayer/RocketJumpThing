shader_type canvas_item;
render_mode unshaded;

const float SHAKE_FREQUENCY = 12.0;
const float MAX_UV_SHIFT = 0.25;

uniform float split_screen = 10.0;


float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment(){
	vec2 uv = UV * split_screen;
	vec2 uv_part = vec2(uv.x,floor(uv.y));
	float time = floor(TIME*SHAKE_FREQUENCY);
	float uv_shift = mod(random(vec2(time,uv_part.y)),MAX_UV_SHIFT); 
	vec2 shifted_uv = vec2(mod(UV.x + uv_shift, 1.0),UV.y);
	COLOR = texture(SCREEN_TEXTURE,shifted_uv);
}