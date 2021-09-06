// Edited by Obrymec.
shader_type canvas_item;
// Monochrome Filter.
uniform vec4 base: hint_color = vec4 (1.0, 1.0, 1.0, 1.0); uniform float red: hint_range (0, 1) = 0.3333;
uniform float green: hint_range (0, 1) = 0.3333; uniform float blue: hint_range (0, 1) = 0.3333;
// Called on any draw.
void fragment () {
	// Generate monochrome effect.
	vec3 c = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float v = dot (c, vec3 (red, green, blue)); v = sqrt (v); COLOR.rgb = (base.rgb * v);
}