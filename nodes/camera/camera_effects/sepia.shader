// Edited by Obrymec.
shader_type canvas_item; uniform vec4 base: hint_color;
// This method is called on any draw.
void fragment () {
	// Generate Sepia effect.
	vec3 c = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float v = dot (c, vec3 (0.33333, 0.33333, 0.33333)); v = sqrt (v); COLOR.rgb = (base.rgb * v);
}