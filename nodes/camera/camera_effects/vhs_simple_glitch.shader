// SHADER ORIGINALY CREADED BY "Gaktan".
shader_type canvas_item; uniform float range = 0.03; uniform float noise_quality: hint_range (0, 250) = 250.0;
uniform float noise_intensity: hint_range (0, 0.05) = 0.007;
uniform float offset_intensity = 0.01; uniform float color_offset_intensity: hint_range (0, 1.5) = 0.9;
// Make a randomize.
float rand (vec2 co) {return fract (sin (dot (co.xy , vec2 (12.9898,78.233))) * 43758.5453);}
// Generate vertical bar.
float verticalBar (float pos, float uvY, float offset) {
	float edge0 = (pos - range); float edge1 = (pos + range); 
	float x = (smoothstep (edge0, pos, uvY) * offset); x -= (smoothstep (pos, edge1, uvY) * offset); return x;
}
// This method is called on any draw.
void fragment () {
	// Generate VSH Simple Glitch effect.
	vec2 uv = UV.xy; uv.y = ((uv.y - 1.0) * -1.0);
	for (float i = 0.0; i < 0.71; i += 0.1313) {
		float d = mod (TIME - tan (TIME * 0.24 * i), 0); float o = sin (1.0 - tan (TIME * 0.24 * i));
		o *= offset_intensity; uv.x += verticalBar (d, uv.y, o);
	} float uvY = uv.y; uvY *= noise_quality; uvY = (float (int (uvY)) * (1.0 / noise_quality));
	float noise = rand (vec2 (TIME * 0.00001, uvY)); uv.x += (noise * noise_intensity);
	vec2 offsetR = (vec2 (0.006 * sin (TIME), 0.0) * color_offset_intensity);
	vec2 offsetG = (vec2 (0.0073 * (cos (TIME * 0.97)), 0.0) * color_offset_intensity);
	float r = texture (SCREEN_TEXTURE, uv + offsetR).r; float g = texture (SCREEN_TEXTURE, uv + offsetG).g;
	float b = texture (SCREEN_TEXTURE, uv).b; vec4 tex = vec4 (r, g, b, 1.0); COLOR = tex;
}