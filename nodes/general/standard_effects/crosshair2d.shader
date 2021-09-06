// Edited by Obrymec.
shader_type canvas_item; uniform float spread = 1.0;
// Attributes.
uniform bool use_center = true; uniform bool use_legs = true;
uniform bool inverted = false; uniform int color_id = 0;
uniform vec4 color_0: hint_color = vec4 (0.0, 1.0, 0.0, 1.0);
uniform vec4 color_1: hint_color = vec4 (1.0, 0.0, 0.0, 1.0);
uniform vec4 color_2: hint_color = vec4 (0.0, 0.0, 1.0, 1.0);
uniform float center_radius = 0.002; uniform float width = 2.0;
uniform float len = -0.02; uniform float spacing = 0.0;
// This function is called on any draw.
void fragment () {
	// Generate crosshair effect.
	float a = (SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);
	vec2 UVa = vec2 (UV.x / a, UV.y); vec2 center = vec2 ((0.5 / a), 0.5);
	float point = step (distance (UVa, center), center_radius);
	float h = step ((center.x - len - spacing * spread), UVa.x) - step ((center.x - spacing * spread), UVa.x);
	h += step ((center.x + spacing * spread), UVa.x) - step ((center.x + len + spacing * spread), UVa.x);
	h *= (step ((center.y - width), UVa.y) - step ((center.y + width), UVa.y));
	float v = step ((center.y - len - spacing * spread), UVa.y) - step ((center.y - spacing * spread), UVa.y);
	v += step ((center.y + spacing * spread), UVa.y) - step ((center.y + len + spacing * spread), UVa.y);
	v *= (step ((center.x - width), UVa.x) - step ((center.x + width), UVa.x));
	float crosshair; crosshair = ((h + v) * float (use_legs) + point * float (use_center));
	if (!inverted) COLOR = ((color_0 * float (color_id == 0) + color_1 *
	float (color_id == 1) + color_2 * float (color_id == 2)) * crosshair);
	else COLOR = (vec4 ((cos (textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0)
	.rgb * 3.1415926534) + 1.0) / 2.0, 1.0) * crosshair);
}