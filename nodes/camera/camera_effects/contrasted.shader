// Edited by Obrymec.
shader_type canvas_item; uniform float intensity: hint_range (0.0, 1.0) = 0.5; 
// This method is called on any draw.
void fragment () {
	// Generate Contrasted effect.
	vec3 c = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	c = mod (c + vec3 (intensity), vec3 (intensity + 0.5)); COLOR.rgb = c;
}