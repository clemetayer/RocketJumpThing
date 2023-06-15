// NOTE: Shader automatically converted from Godot Engine 3.5.2.stable's SpatialMaterial.

shader_type spatial;
render_mode async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_roughness : hint_white;
uniform vec4 roughness_texture_channel;
uniform sampler2D texture_emission : hint_black_albedo;
uniform vec4 emission : hint_color;
uniform float emission_energy;
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform sampler2D texture_ambient_occlusion : hint_white;
uniform vec4 ao_texture_channel;
uniform float ao_light_affect;
uniform sampler2D texture_depth : hint_black;
uniform float depth_scale;
uniform int depth_min_layers;
uniform int depth_max_layers;
uniform vec2 depth_flip;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
// Custom things
const vec2 window_size = vec2(0.3,0.05);
const float window_intensity = 4.0;
const float window_fract = 4.0;
const float window_draw_trigger = 0.75; // Chance a window will be drawn
uniform vec4 window_color : hint_color;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


float horizontal_line(float x1, float x2, float y, float width, vec2 uv)
{
	return (step(uv.y, y-width) - step(uv.y,y+width)) * (step(uv.x,x1) - step(uv.x,x2));
}

float draw_window(vec2 uv){
	float ret_val = 0.0;
	for (int row = 0; row < int(1.0/(window_size.y)); row ++ ){
		float trigger_window = random(vec2(0.0,float(row)));
		if(trigger_window <= window_draw_trigger){
			float analog_start_x_pos = random(vec2(float(row),0.0));
			float start_x_pos = round(analog_start_x_pos * window_fract)/window_fract;
			float end_x_pos = mod(start_x_pos + window_size.x,1.0);
			if(end_x_pos < start_x_pos){ // means that the line will go over the right edge
				ret_val += horizontal_line(start_x_pos, 1.0, float(row) * window_size.y * 2.0 , window_size.y/2.0, uv);
				ret_val += horizontal_line(0.0, end_x_pos, float(row) * window_size.y * 2.0, window_size.y/2.0, uv);
			} 
			else{
				ret_val += horizontal_line(start_x_pos, end_x_pos, float(row) * window_size.y * 2.0, window_size.y/2.0, uv);
			}
		}
	}
	return ret_val;
}

float square(vec2 uv)
{
	uv = uv * 2.0 - 1.0;
	
	vec2 abs_uv = abs(uv.xy);
	float square = step(window_size.x/2.0, max(abs_uv.x, abs_uv.y));
	return 1.0 - square;
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	// Custom things
	float window = draw_window(fract(UV/3.0));
	if(window > 0.0){
		ALBEDO = window_color.rgb;
		EMISSION = ALBEDO * window_intensity;
	}
	// Generated
	else{
		vec2 base_uv = UV;
		{
			vec3 view_dir = normalize(normalize(-VERTEX)*mat3(TANGENT*depth_flip.x,-BINORMAL*depth_flip.y,NORMAL));
			float num_layers = mix(float(depth_max_layers),float(depth_min_layers), abs(dot(vec3(0.0, 0.0, 1.0), view_dir)));
			float layer_depth = 1.0 / num_layers;
			float current_layer_depth = 0.0;
			vec2 P = view_dir.xy * depth_scale;
			vec2 delta = P / num_layers;
			vec2 ofs = base_uv;
			float depth = textureLod(texture_depth, ofs, 0.0).r;
			float current_depth = 0.0;
			while(current_depth < depth) {
				ofs -= delta;
				depth = textureLod(texture_depth, ofs, 0.0).r;
				current_depth += layer_depth;
			}
			vec2 prev_ofs = ofs + delta;
			float after_depth  = depth - current_depth;
			float before_depth = textureLod(texture_depth, prev_ofs, 0.0).r - current_depth + layer_depth;
			float weight = after_depth / (after_depth - before_depth);
			ofs = mix(ofs,prev_ofs,weight);
			base_uv=ofs;
		}
		vec4 albedo_tex = texture(texture_albedo,base_uv);
		ALBEDO = albedo.rgb * albedo_tex.rgb;
		METALLIC = metallic;
		float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
		ROUGHNESS = roughness_tex * roughness;
		SPECULAR = specular;
		NORMALMAP = texture(texture_normal,base_uv).rgb;
		NORMALMAP_DEPTH = normal_scale;
		vec3 emission_tex = texture(texture_emission,base_uv).rgb;
		EMISSION = (emission.rgb+emission_tex)*emission_energy;
		AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
		AO_LIGHT_AFFECT = ao_light_affect;
	}
}
