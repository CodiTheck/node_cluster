// Edited by Obrymec.
shader_type canvas_item; uniform float size: hint_range (0, 100) = 10.0;
// Called on any draw.
void fragment () {
	// Generate a simple mosic effect.
	vec2 moz = (floor (FRAGCOORD.xy / size) * size);
	COLOR = vec4 ((texelFetch (SCREEN_TEXTURE, ivec2 (moz), 0).xyz), 1.0);
}