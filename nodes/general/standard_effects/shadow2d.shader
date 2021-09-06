// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform vec4 color: hint_color = vec4 (0.0, 0.0, 0.0, 1.0);
uniform int x_offset: hint_range (-20, 20) = 10; uniform int y_offset: hint_range (-20, 20) = 10;
// This method is called on every draw.
void fragment () {
	// Generate shadow effect.
	vec4 c = texture (TEXTURE, UV); if (c.a > 0.001) COLOR = c;
	else {
		vec2 offset = (vec2 (float (-x_offset), float (-y_offset)) * TEXTURE_PIXEL_SIZE);
		vec4 c2 =  texture (TEXTURE, (UV + offset)); if (c2.a > 0.001) COLOR = (color * c2); else discard;
	}
}