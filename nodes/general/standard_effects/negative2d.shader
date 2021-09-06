// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded; uniform float factor: hint_range (0, 1) = 1;
// This function is called on any draw.
void fragment () {
	// Generate negative effect.
	vec4 c = texture (TEXTURE, UV); vec4 c2 = vec4 ((1.0 - c.r), (1.0 - c.g), (1.0 - c.b), c.a);
	COLOR = mix (c, c2, factor);
}