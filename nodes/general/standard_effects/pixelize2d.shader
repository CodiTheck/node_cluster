// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded, skip_vertex_transform;
// Attributes.
uniform float factor: hint_range (0, 1) = 0.3; 
// Generate vertex.
void vertex () {VERTEX = (WORLD_MATRIX * vec4 (VERTEX, 0.0, 1.0)).xy;}
// This function is called on any draw.
void fragment () {
	// Generate pixelize effect.
	vec2 size = ((factor * 20f - 1f) * TEXTURE_PIXEL_SIZE);
	vec2 uv2 = (round (UV / size) * size); COLOR = texture (TEXTURE, uv2);
}