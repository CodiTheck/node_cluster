// SHADER ORIGINALY CREADED BY "keijiro".
shader_type canvas_item;
// Attributes.
uniform float scan_line_jitter: hint_range (0.2, 1) = 0.25;
uniform float vertical_jump: hint_range (0, 1) = 0.01;
uniform float horizontal_shake: hint_range (0, 1) = 0; uniform float color_drift: hint_range (0, 1) = 0.02;
// Randomize.
float nrand (float x, float y) {return fract (sin (dot (vec2 (x, y), vec2 (12.9898, 78.233))) * 43758.5453);}
// This method is called on any draw.
void fragment () {
	// Generate vhs glitch effect.
	float sl_thresh = dot (vec2 (1.0 - scan_line_jitter * 1.2), vec2 (1.0 - scan_line_jitter * 1.2));
	float sl_disp = (0.002 + pow (scan_line_jitter, 3) * 0.05); vec2 sl = vec2 (sl_disp, sl_thresh);
	float vertical_jumpTime = (TIME * vertical_jump * 11.3); vec2 vj = vec2 (vertical_jump, vertical_jumpTime);
	float hs = (horizontal_shake * 0.2); vec2 cd = vec2 (color_drift * 0.04f, TIME * 606.11f);
	float u = SCREEN_UV.x; float v = SCREEN_UV.y;
	// Scan line jitter.
	float jitter = (nrand (v, TIME) * 2.0 - 1.0);
	jitter *= (step (sl.y, abs (jitter)) * sl.x);
	// Vertical jump.
	float jump = mix (v, fract (v + vj.y), vj.x);
	// Horizontal shake.
	float shake = ((nrand (TIME, 2) - 0.5) * hs);
	// Color drift.
	float drift = (sin (jump + cd.y) * cd.x);
	vec4 final1 = texture (SCREEN_TEXTURE, fract (vec2 ((u + jitter + shake), jump)));
	vec4 final2 = texture (SCREEN_TEXTURE, fract (vec2 ((u + jitter + shake + drift), jump)));
	vec4 render = vec4 (final1.r, final2.g, final1.b, 1); COLOR = render;
}