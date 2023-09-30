// NOTE: Shader automatically converted from Godot Engine 3.5.2.stable's SpatialMaterial.

shader_type spatial;
render_mode async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

// Generated
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
// My stuff
uniform sampler2D runes_color_gradient;
uniform float emission;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	// Generated
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	NORMALMAP = texture(texture_normal,base_uv).rgb;
	NORMALMAP_DEPTH = normal_scale;
	// My stuff 
	if(ALBEDO.r >= 0.01){
		vec3 rune_col = texture(runes_color_gradient,vec2((sin(UV.x + TIME)/2.0)+0.5, UV.y)).rgb;
		float mix_val = ((sin(UV.y + TIME)/2.0)+0.5)*0.4;
		ALBEDO = mix(ALBEDO,rune_col,mix_val);
		EMISSION = ALBEDO * emission * mix_val;
		ALPHA = mix_val;
	}
	else{
		ALPHA = 0.0;
	}
}
