// Edited by Obrymec.
shader_type canvas_item;
// Edge Detection & Motion Filter.
uniform float line_size: hint_range (0, 100) = 10; uniform float threshold: hint_range (0, 50) = 10;
uniform float line_weight: hint_range (0, 1) = 0.7; uniform float gradation_size: hint_range (0, 100) = 20;
uniform float weight: hint_range (0, 1) = 0.7;
// Called on any draw.
void fragment () {
	// Generate edge motion mix effect.
	float size = (line_size / 10000.0); float limit = (threshold / 100.0);
	vec3 col = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float depth_left = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (-size, 0))).r;
	float depth_right = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (size, 0))).r;
	float depth_down = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (0, -size))).r;
	float depth_up = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (0, size))).r;
	float depth_diff = abs (depth_left - depth_right); depth_diff += abs (depth_up - depth_down);
	float Count = (gradation_size * 2.0 + 1.0); vec3 col_2 = vec3 (0.0);
	for (int i = int (-gradation_size); i <= int (gradation_size); i++) {
		for (int j = int (-gradation_size); j <= int (gradation_size); j++) {
			vec2 quat_xy = vec2 ((float (i) * SCREEN_PIXEL_SIZE.x), (float (j) * SCREEN_PIXEL_SIZE.y));
			if (i == j) col_2 += (texture (SCREEN_TEXTURE, vec2 (SCREEN_UV + quat_xy)).xyz / Count);
		}
	}
	if (depth_diff > limit) COLOR = (vec4 (col_2, weight) * 0.0 + vec4 (0.0, 0.0, 0.0, 1.0) * line_weight);
	else COLOR = vec4 (col_2, weight);
}