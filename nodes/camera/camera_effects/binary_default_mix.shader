// Edited by by Obrymec.
shader_type canvas_item;
// Binary Conversion & Default Filter.
uniform float threshold: hint_range (0, 50) = 10; uniform float line_weight: hint_range (0, 1) = 0.7;
uniform float gradation_size: hint_range (0, 10) = 3; uniform float weight: hint_range (0, 1) = 0.7;
// This method is called on any draw.
void fragment () {
	// Generate binary conversion.
	vec3 col = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb; float temp = (col.r + col.g + col.b);
	if (temp > threshold) col = vec3 (1.0, 1.0, 1.0); else col = vec3 (0.0, 0.0, 0.0);
	COLOR = (vec4 (col, 1.0) * line_weight + vec4 (textureLod (SCREEN_TEXTURE, SCREEN_UV,
	gradation_size).rgb, weight));
}