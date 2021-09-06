// Edited by Obrymec.
shader_type canvas_item; uniform float frequency = 60; uniform float depth = 0.005;
// This method is called on any draw.
void fragment () {
	// Generate Mirage effect.
	vec2 uv = SCREEN_UV; uv.x += (sin (uv.y * frequency + TIME) * depth);
	uv.x = clamp (uv.x, 0.0, 1.0); vec3 c = textureLod (SCREEN_TEXTURE, uv, 0.0).rgb; COLOR.rgb = c;
}