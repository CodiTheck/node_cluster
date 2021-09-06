// Edited by Obrymec.
shader_type canvas_item; uniform vec2 size = vec2 (0.01, 0.01);
// This method is called on any draw.
void fragment () {
	// Generate Pixelize effect.
	vec2 uv = SCREEN_UV; uv -= mod (uv, vec2 (size.x, size.y));
	COLOR.rgb = textureLod (SCREEN_TEXTURE, uv, 0.0).rgb;
}