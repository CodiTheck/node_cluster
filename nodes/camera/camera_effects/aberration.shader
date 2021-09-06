// Edited by Obrymec.
shader_type canvas_item;
// Avanced Aberration Filter.
uniform float amount: hint_range (0.0, 5.0) = 0.50;
uniform float center_fade: hint_range (0.0, 1.0) = 0.154;
uniform vec2 aberration_center = vec2 (0.5, 0.5);
// This method is called on any draw.
void fragment () {
	// Generate Advanced aberation filter.
	vec2 coords = (UV - aberration_center);
	float jamount = (amount * 0.1 * mix (dot (coords, coords), 1.0, center_fade));
	vec4 color = texture (SCREEN_TEXTURE, SCREEN_UV);
	color.r = texture (SCREEN_TEXTURE, vec2 ((SCREEN_UV.x + jamount), SCREEN_UV.y)).r;
	color.b = texture (SCREEN_TEXTURE, vec2 ((SCREEN_UV.x - jamount), SCREEN_UV.y)).b; COLOR = color; 
}