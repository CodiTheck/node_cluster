// Edited by Obrymec.
shader_type spatial; render_mode cull_disabled, specular_disabled,
diffuse_lambert, unshaded; const float TWO_PI = 6.28318530718;
// Generate hsb2rgb.
vec3 hsb2rgb (in vec3 c) {
	vec3 rgb = clamp (abs (mod (c.x * 6.0 + vec3 (0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
	rgb = rgb * rgb * (3.0 - 2.0 * rgb); return (c.z * mix (vec3 (1.0), rgb, c.y));
}
// Called on every draw.
void fragment () {
	// Generate a gradient 3d effect.
	vec2 st = UV; vec3 color = vec3 (0.0); vec2 toCenter = (vec2 (0.5) - st);
	// Use polar coordinates instead of cartesian.
	float angle = atan (toCenter.y, toCenter.x); float radius = (length (toCenter) * 2.0);
	// Map the angle (-PI to PI) to the Hue (from 0 to 1) and the Saturation to the radius.
	color = hsb2rgb (vec3 ((angle / TWO_PI) + 0.5, radius, 1.0)); ALBEDO = color;
}