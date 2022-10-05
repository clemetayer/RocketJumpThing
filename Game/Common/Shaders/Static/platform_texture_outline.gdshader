shader_type spatial;

//---- Other parameters ----
uniform vec4 inner_color : hint_color = vec4(1,1,1,1);
uniform vec4 outer_color : hint_color = vec4(1,1,1,1);
uniform float outer_size = 0.1;
uniform float emission_intensity = 3.0;

void fragment(){
	// fract uv to map shade each face of the cube
	vec2 uv = UV;
	uv.x = fract(uv.x * 3.0);
	uv.y = fract(uv.y * 2.0);
	// set alpha
	if(min(step(uv.x,0.1) + step(uv.y,0.1) + (1.0 - step(uv.x,0.9)) + (1.0 - step(uv.y,0.9)),1.0) == 1.0){ // Color the outline
		ALBEDO = outer_color.rgb;
		ALPHA = outer_color.a;
		EMISSION = outer_color.rgb * emission_intensity;
	}
	else{ // Color the inner side
		ALBEDO = inner_color.rgb;
		ALPHA = inner_color.a;
	}
	//ALBEDO = vec3(uv.x,uv.y,0.0);
}