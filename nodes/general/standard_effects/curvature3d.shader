// Edited by Obrymec.
shader_type spatial; render_mode world_vertex_coords,
depth_draw_alpha_prepass, cull_disabled, vertex_lighting;
// Attributes.
uniform float curvature = 5.0; uniform float curvature_distance = 10.0; uniform sampler2D base_texture;
// Generate vertex.
void vertex () {
	NORMAL = (WORLD_MATRIX * vec4 (NORMAL, 0.0)).xyz;
	float dist = (length (CAMERA_MATRIX [3].xyz - VERTEX) / curvature_distance);
	VERTEX.y -= pow (dist, curvature);
}
// Called on any draw.
void fragment () {
	// Generate curvature effect.
	vec4 tex = texture (base_texture, UV); if (tex.a < 0.3) discard; ALBEDO = tex.rgb; ALPHA = tex.a;
}