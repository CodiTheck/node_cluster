// Edited by Obrymec.
shader_type canvas_item;
// Background Noise.
uniform mat2 rot = mat2 (vec2 (0.5, 0.86), vec2 (-0.86, 0.5));
uniform float speed = 1.1; uniform float gradation: hint_range (0, 2) = 0.5;
// Calculate the wave.
float wave (vec2 p) {float v = sin (p.x + sin (p.y) + sin (p.y * 0.43)); return (v * v);}
// Calculate the noise map.
float map (float time, vec2 p) {
	float v = 0.0; v += wave (p); p.x += (time * speed); p = (p * rot);
	v += wave (p); p.x += (time * speed * 0.17); p = (p * rot);
	v += wave (p); v = abs (1.5 - v); return v;
}
// This method is called on any draw.
void fragment () {
	// Generate background noise effect.
	vec2 resolution = (1.0 / SCREEN_PIXEL_SIZE);
	vec2 uv = ((FRAGCOORD.xy * 2.0 - resolution.xy) / min (resolution.x, resolution.y));
	vec2 p = (normalize (vec3 (uv.xy, 2.3)).xy * 10.0); p.y += (TIME * speed * 0.3);
	float v = map (TIME, p); COLOR = vec4 (((v * 0.7 + texture (SCREEN_TEXTURE, SCREEN_UV).r) / 2.0),
	((v * 0.3 + texture (SCREEN_TEXTURE, SCREEN_UV).g) / 2.0),
	(v * 0.49 + texture (SCREEN_TEXTURE,SCREEN_UV).b / 2.0), gradation);
}