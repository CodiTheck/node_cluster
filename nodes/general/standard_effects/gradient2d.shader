// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded, skip_vertex_transform;
// Attributes.
uniform vec4 color_ul: hint_color = vec4 (1.0, 0.0, 0.0, 1.0);
uniform vec4 color_ur: hint_color = vec4 (0.0, 1.0, 0.0, 1.0);
uniform vec4 color_bl: hint_color = vec4 (0.0, 0.0, 1.0, 1.0);
uniform vec4 color_br: hint_color = vec4 (1.0, 0.0, 0.0, 0.0);
uniform float factor: hint_range (0, 1) = 0.5; varying vec4 gradient;
// Generate vertex color.
void vertex () {
	VERTEX = (WORLD_MATRIX * vec4 (VERTEX, 0.0, 1.0)).xy; vec4 lru = mix (color_ul, color_ur, UV.x);
	vec4 lrb = mix (color_bl, color_br, UV.x); gradient = mix (lru, lrb, UV.y);
}
// This method is called on every draw.
void fragment () {vec4 c = texture (TEXTURE, UV); COLOR = mix (c, c * gradient, factor);}