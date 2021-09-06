// Edited by Obrymec.
shader_type canvas_item;
// Edge Detection.
uniform float size: hint_range (0, 100) = 10; uniform float threshold: hint_range (0, 50) = 10;
// Called on any draw.
void fragment () {
	// Generate edge detection effect.
	float jsize = (size / 10000.0); float limit = (threshold / 100.0);
	float depth_left = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (-jsize, 0))).r;
	float depth_right = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (jsize, 0))).r;
	float depth_down = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (0, -jsize))).r;
	float depth_up = texture (SCREEN_TEXTURE, (SCREEN_UV + vec2 (0, jsize))).r;
	float depth_diff = abs (depth_left - depth_right); depth_diff += abs (depth_up - depth_down);
	if (depth_diff > limit) COLOR.rgb = vec3 (0.0, 0.0, 0.0); else COLOR.rgb = vec3 (1.0, 1.0, 1.0);
}