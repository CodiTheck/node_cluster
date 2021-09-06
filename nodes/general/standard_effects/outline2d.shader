// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform vec4 color: hint_color = vec4 (1.0, 1.0, 1.0, 1.0);
uniform int border_size: hint_range (1, 30) = 20;
uniform float border_filter: hint_range (0.01, 0.9) = 0.5;
// Return the corresponding direction.
vec2 get_direction (int k) {
	if (k == 1) return vec2 (1.0, 0); else if (k == 2) return vec2 (-1.0, 0);
	else if (k == 3) return vec2 (0, 1.0); else return vec2 (0, -1.0);
}
// This method is called on every draw.
void fragment () {
	// Generate outline effect.
	vec4 c = texture (TEXTURE, UV); if (c.a > border_filter) COLOR = c;
	else {int min_length = (border_size + 1);
		for (int i = 1; i <= 4; i++) {
			for (int j = 1; j < min_length; j++) {
				vec4 c2 = texture (TEXTURE, (UV + get_direction (i) *
				TEXTURE_PIXEL_SIZE * float (j))); if (c2.a > 0.01) min_length = j;
			}
		} if (min_length > border_size) discard;
		else {COLOR = color; COLOR.a = mix (1.0, 0.0, (float (min_length - 1) / float (border_size)));}
	}
}