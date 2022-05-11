// NOTE: Shader automatically converted from Godot Engine 3.4.4.stable's SpatialMaterial.

shader_type spatial;
uniform sampler2D texture_albedo : hint_albedo;

const float intensity = 2.0;

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	albedo_tex *= COLOR;
	ALBEDO = albedo_tex.rgb;
	EMISSION = ALBEDO * intensity;
	ALPHA = albedo_tex.a;
}
