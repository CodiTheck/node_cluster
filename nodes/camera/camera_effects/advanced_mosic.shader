// Edited by Obrymec.
shader_type canvas_item; uniform float size: hint_range (0, 100) = 10.0;
// This method is called on any draw.
void fragment () {
	// Generate advanced mosic effect.
	vec2 moz = (floor (FRAGCOORD.xy / size) * size); vec4 temp = vec4 (0.0);
	for (int i = 0; i < int (size); i++) {
		for (int j = 0; j < int (size); j++) {
			vec2 quat_xy = vec2 (float (i), float (j));
			temp += vec4 ((texelFetch (SCREEN_TEXTURE, ivec2 (moz + quat_xy), 0).xyz), 1.0);
		}
	} COLOR = vec4 (temp.rgb / size / size, 1.0);
}