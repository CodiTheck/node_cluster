// Mosaic shader for 3D spatial by Yui Kinomoto @arlez80.
shader_type spatial; render_mode unshaded; uniform float size = 50.0;
// This method is called on any draw.
void fragment () {
	// Generate mosaic effect.
	vec2 p = (floor (FRAGCOORD.xy / size) * size);
	vec2 quat_x = vec2 (size / 4.0, 0); vec2 quat_y = vec2 (0, quat_x.x);
	ALBEDO = ((
		texelFetch (SCREEN_TEXTURE, ivec2 (p), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_x), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_x * 2.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_x * 3.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y + quat_x), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y + quat_x * 2.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y + quat_x * 3.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 2.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 2.0 + quat_x), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 2.0 + quat_x * 2.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 2.0 + quat_x * 3.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 3.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 3.0 + quat_x), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 3.0 + quat_x * 2.0), 0).xyz +
		texelFetch (SCREEN_TEXTURE, ivec2 (p + quat_y * 3.0 + quat_x * 3.0), 0).xyz
	) / 16.0);
}