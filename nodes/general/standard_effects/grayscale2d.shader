// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded; uniform float factor: hint_range (0, 1) = 1; 
// This method is called on any draw.
void fragment () {
	// Generate grayscale effect.
	vec4 c = texture (TEXTURE, UV); float p = ((c.r + c.g + c.b) / 3.0f);
	vec4 c2 = vec4 (p, p, p, c.a); COLOR = mix (c, c2, factor);
}