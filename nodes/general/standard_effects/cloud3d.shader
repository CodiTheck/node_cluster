// Cloud Shader by Yui Kinomoto @arlez80.
shader_type spatial; render_mode depth_draw_never, cull_back, unshaded,
shadows_disabled; const float noise_scale = 0.00005;
// Attributes.
uniform float seed = -1000.0; uniform vec2 speed = vec2 (2.0, 0.0);
uniform vec2 transform_speed = vec2 (0.0, 0.0001);
uniform vec4 color: hint_color = vec4 (1.0, 1.0, 1.0, 1.0);
uniform float min_density = 0.46; uniform float max_density = 6.0;
uniform float altitude = 2000.0; uniform bool detail_noise = false;
uniform bool use_upper = true; uniform bool use_lower = false;
// Make a random.
float random (vec2 pos) {return fract (sin (dot (pos, vec2 (12.9898,78.233))) * 43758.5453);}
// Generate noise.
float value_noise (vec2 pos) {
	vec2 p = floor (pos); vec2 f = fract (pos); float v00 = random (p + vec2 (0.0, 0.0));
	float v10 = random (p + vec2 (1.0, 0.0)); float v01 = random (p + vec2 (0.0, 1.0));
	float v11 = random (p + vec2 (1.0, 1.0)); vec2 u = (f * f * (3.0 - 2.0 * f));
	return mix (mix (v00, v10, u.x), mix (v01, v11, u.x), u.y);
}
// This function is called on every draw.
void fragment () {
	// Generate cloud effect.
	vec3 camera_pos = (CAMERA_MATRIX * vec4 (0.0, 0.0, 0.0, 1.0)).xyz;
	vec3 v = -(vec4 (VIEW, 1.0) * INV_CAMERA_MATRIX).xyz; float sin_theta = v.y;
	if ((0.0 < sin_theta && (!use_upper)) || (sin_theta < 0.0 && (!use_lower))) discard;
	float distance_to_p = (altitude / sin_theta); vec3 p = (camera_pos + v * distance_to_p);
	vec2 pos_a = ((vec2 (p.x, p.z + seed) + (TIME * speed)) * noise_scale);
	vec2 pos_b = (pos_a + transform_speed * TIME);
	float h = ((
		(value_noise (pos_a) * 8.0) + (value_noise (pos_a * 4.2) * 8.0) +
		(value_noise (pos_a * 8.4) * 8.0) + (value_noise (pos_a * 17.6) * 8.0) +
		(value_noise (pos_a * 61.8) * 4.0) + (value_noise (pos_b * 90.1) * 4.0) +
		(value_noise (pos_b * 110.1) * 2.0) + (value_noise (pos_b * 220.0) * 2.0) +
		(value_noise (pos_b * 680.0) + value_noise (pos_b * 1200.0) +
		value_noise (pos_b * 6000.0)) * (detail_noise ? 1.0 : 0.45)) / 47.0);
	ALPHA = min (abs (sin_theta) * 8.0, 1.0) * clamp ((h - min_density)
	* (max_density - min_density), 0.0, 1.0); ALBEDO = color.rgb; DEPTH = 1.0;
}