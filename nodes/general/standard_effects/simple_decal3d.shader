// Edited Obrymec. 
shader_type spatial; render_mode unshaded, depth_draw_never, cull_front, depth_test_disable;
// Attributes.
uniform sampler2D decal: hint_black; uniform vec2 offset;
uniform vec2 scale = vec2 (1.0, 1.0); uniform bool emulate_lighting;
uniform float brightness; varying flat mat4 model_view_matrix;
// Get matrix vertex.
void vertex () {model_view_matrix = MODELVIEW_MATRIX;}
// This method is called on any.
void fragment () {
	// Generate a simple decal effect.
	vec4 pos = inverse (model_view_matrix) * INV_PROJECTION_MATRIX *
	vec4 (SCREEN_UV * 2.0 - 1.0, textureLod (DEPTH_TEXTURE, SCREEN_UV, 0.0).r * 2.0 - 1.0, 1.0);
	pos.xyz /= pos.w; bool inside = all (greaterThanEqual (pos.xyz, vec3 (-1.0)))
	&& all (lessThanEqual (pos.xyz, vec3 (1.0)));
	if (inside) {
		vec4 color = texture (decal, (pos.xy * -0.5 - 0.5) * scale + offset);
		if (emulate_lighting) {
			float lum = dot (textureLod (SCREEN_TEXTURE, SCREEN_UV, 0).rgb, vec3 (0.2125, 0.7154, 0.0721));
			lum += brightness; lum = clamp (lum, 0.0, 1.0); ALBEDO = (color.rgb * lum);
		} else ALBEDO = color.rgb;
		ALPHA = color.a;
	} else discard;
}