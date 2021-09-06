// Edited by Obrymec.
shader_type canvas_item; uniform float size: hint_range (0, 100) = 10;
// Called on any draw.
void fragment () {
	// Generate motion effect.
	float Count = (size * 2.0 + 1.0); vec4 col = vec4 (0.0);
	for (int i = int (-size); i <= int (size); i++) {
		for (int j = int (-size); j <= int (size); j++) {
			vec2 quat_xy = vec2 ((float (i) * SCREEN_PIXEL_SIZE.x), (float (j) * SCREEN_PIXEL_SIZE.y));
			if (i == j) col += (texture (SCREEN_TEXTURE, vec2 (SCREEN_UV + quat_xy)) / Count);
		}
	} COLOR = col;
}