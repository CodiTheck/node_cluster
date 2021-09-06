// Edited by Obrymec.
shader_type spatial; render_mode skip_vertex_transform, diffuse_lambert_wrap, specular_disabled, cull_disabled;
// Attributes.
uniform vec4 color: hint_color; uniform sampler2D albedo_texture: hint_albedo;
uniform float specular_intensity: hint_range (0.0, 1.0); uniform vec2 uv_scale = vec2 (1.0, 1.0);
uniform float resolution = 256; uniform float cull_distance = 5;
uniform float affine_texture_mapping_amount: hint_range (0.0, 2.0);
uniform vec2 uv_offset = vec2 (0.0, 0.0); varying vec4 vertex_coordinates;
// Generate vertex.
void vertex () {
	UV = (UV * uv_scale + uv_offset); float vertex_distance = length ((MODELVIEW_MATRIX * vec4 (VERTEX, 1.0)));
	VERTEX = (MODELVIEW_MATRIX * vec4 (VERTEX, 1.0)).xyz;
	float vPos_w = (PROJECTION_MATRIX * vec4 (VERTEX, 1.0)).w;
	VERTEX.xy = (vPos_w * floor (resolution * VERTEX.xy / vPos_w) / resolution);
	vertex_coordinates = vec4 ((UV * VERTEX.z), VERTEX.z, .0);
	if (vertex_distance > cull_distance) VERTEX = vec3 (0.0);
}
// Called on any draw.
void fragment () {
	// Generate psx lit effect.
	vec4 tex = texture (albedo_texture, mix ((vertex_coordinates.xy /
	vertex_coordinates.z), UV.xy, affine_texture_mapping_amount));
	ALBEDO = (tex.rgb * color.rgb); SPECULAR = specular_intensity;
}