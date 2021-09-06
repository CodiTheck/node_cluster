// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix; uniform float size: hint_range (0, 100) = 10;
// This method is called on any draw.
void fragment () {
	// Generate average effect.
	float Count = ((size * 2.0 + 1.0) * (size * 2.0 + 1.0)); vec4 col = vec4 (0.0);
	for (int i = int (-size); i <= int (size); i++) {
		for (int j = int (-size); j <= int (size); j++) {
			vec2 quat_xy = vec2 ((float (i) * SCREEN_PIXEL_SIZE.x), (float (j) * SCREEN_PIXEL_SIZE.y));
			col += (textureLod (SCREEN_TEXTURE, SCREEN_UV + quat_xy, 0.0) / Count);
		}
	} COLOR = col;
}