// SHADER ORIGINALY CREADED BY "ehj1".
shader_type canvas_item; render_mode blend_mix; varying float time;
// Change these values to 0.0 to turn off individual effects.
uniform float vert_jerk_opt: hint_range (0, 1) = 1.0; uniform float vert_movement_opt: hint_range (0, 1) = 1.0;
uniform float scalines_opt: hint_range (0, 6) = 1.0; uniform float rgb_offset_opt: hint_range (0, 2) = 1.0;
uniform float horz_fuzz_opt: hint_range (0, 5) = 1.0; uniform float bottom_static_opt: hint_range (0, 5) = 1.0;
// Apply vertex.
void vertex () {time = TIME;}
// Generate mod289vect3.
vec3 mod289vec3 (vec3 x) {return (x - floor (x * (1.0 / 289.0)) * 289.0);}
// Generate mod289vect2.
vec2 mod289vec2 (vec2 x) {return (x - floor (x * (1.0 / 289.0)) * 289.0);}
// Generate the permuted mod289vec3.
vec3 permute (vec3 x) {return mod289vec3 (((x * 34.0) + 1.0) * x);}
// Snoise generation.
float snoise (vec2 v) {
	const vec4 C = vec4 (0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
	// First corner.
	vec2 i = floor (v + dot (v, C.yy)); vec2 x0 = (v - i + dot (i, C.xx));
	// Other corners.
	vec2 i1; i1 = (x0.x > x0.y) ? vec2 (1.0, 0.0) : vec2 (0.0, 1.0);
	vec4 x12 = (x0.xyxy + C.xxzz); x12.xy -= i1;
	// Permutations.
	i = mod289vec2 (i); vec3 p = permute (permute (i.y + vec3 (0.0, i1.y, 1.0)) + i.x + vec3 (0.0, i1.x, 1.0));
	vec3 m = max (0.5 - vec3 (dot (x0,x0), dot (x12.xy, x12.xy), dot (x12.zw, x12.zw)), 0.0);
	m = m * m; m = m * m; vec3 x = (2.0 * fract (p * C.www) - 1.0);
	vec3 h = (abs (x) - 0.5); vec3 ox = floor (x + 0.5); vec3 a0 = (x - ox);
	// Normalise gradients implicitly by scaling.
	m *= (1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h));
	// Compute final noise value at P.
	vec3 g; g.x  = (a0.x * x0.x + h.x * x0.y);
	g.yz = (a0.yz * x12.xz + h.yz * x12.yw); return (130.0 * dot (m, g));
}
// Generate static v.
float staticV (vec2 uv) {
	float staticHeight = (snoise (vec2 (9.0, float (time) * 1.2 + 3.0)) * 0.3 + 5.0);
	float staticAmount = (snoise (vec2 (1.0, time * 1.2 - 6.0)) * 0.1 + 0.3);
	float staticStrength = (snoise (vec2 (-9.75, time * 0.6 - 3.0)) * 2.0 + 2.0);
	return ((1.0 - step (snoise (vec2 (5.0 * pow (time, 2.0) + pow (uv.x * 7.0, 1.2),
	pow ((mod (time, 100.0) + 100.0) * uv.y * 0.3 + 3.0, staticHeight))), staticAmount)) * staticStrength);
}
// This method is called on any draw.
void fragment () {
	// Generate TV effect.
	vec2 uv = UV.xy; uv.y = ((uv.y - 1.0) * -1.0);
	float jerkOffset = ((1.0 - step (snoise (vec2 (TIME * 1.3, 5.0)), 0.8)) * 0.05);
	float fuzzOffset = (snoise (vec2 (TIME * 15.0, uv.y * 80.0)) * 0.003);
	float largeFuzzOffset = (snoise (vec2 (TIME * 1.0, uv.y * 25.0)) * 0.004);
	float vertMovementOn = ((1.0 - step (snoise (vec2 (TIME * 0.2, 8.0)), 0.4)) * vert_movement_opt);
	float vertJerk = ((1.0 - step (snoise (vec2 (TIME * 1.5, 5.0)), 0.6)) * vert_jerk_opt);
	float vertJerk2 = ((1.0 - step (snoise (vec2 (TIME * 5.5, 5.0)), 0.2)) * vert_jerk_opt);
	float yOffset = (abs (sin (TIME) * 4.0) * vertMovementOn + vertJerk * vertJerk2 * 0.3);
	float _y = mod (uv.y + yOffset, 1.0); float staticVal = 0.0;
	float xOffset = ((fuzzOffset + largeFuzzOffset) * horz_fuzz_opt);
	for (float y = -1.0; y <= 1.0; y += 1.0) {
		float maxDist = (5.0 / 200.0); float dist = (y / 200.0);
		staticVal += (staticV (vec2 (uv.x, uv.y + dist)) * (maxDist - abs (dist)) * 1.5);
	} staticVal *= bottom_static_opt;
	float red = (texture (SCREEN_TEXTURE, vec2 (uv.x + xOffset -0.01 * rgb_offset_opt, _y)).r + staticVal);
	float green = (texture (SCREEN_TEXTURE, vec2 (uv.x + xOffset, _y)).g + staticVal);
	float blue = (texture (SCREEN_TEXTURE, vec2 (uv.x + xOffset + 0.01 * rgb_offset_opt, _y)).b + staticVal);
	vec3 color = vec3 (red, green, blue); float scanline = (sin (uv.y * 800.0) * 0.04 * scalines_opt);
	color -= scanline; COLOR = vec4 (color, 1.0);
}