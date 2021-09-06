// Edited by Obrymec.
shader_type canvas_item;
// This method is called on any draw.
void fragment () {
	// Generate Negative effect.
	vec3 c = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb; c = (vec3 (1.0) - c); COLOR.rgb = c;
}