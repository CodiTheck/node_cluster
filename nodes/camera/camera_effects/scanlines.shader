// Edited by Obrymec.
shader_type canvas_item;
// Generate a shape.
float sharp (vec2 _a1, float _a2, float _a3, float _a4, float _a5) {
	return step (fract (_a1.y * _a2 + _a5 * _a4), _a3);
}
// This function is called on any draw.
void fragment () {
	// Generate scanlines effect.
	vec3 n_out47p0 = vec3 (UV, 0.0); float n_out48p0 = 21.000000;
	float n_out49p0 = 0.300000; float n_out50p0 = 0.200000;
	float n_out51p0 = TIME; vec3 n_out52p0 = vec3 (0.000000, 1.000000,
	0.557237); float n_out52p1 = 1.000000; vec3 n_out46p0;
	float n_out46p1; {
		n_out46p0 = n_out52p0; n_out46p1 = (sharp (n_out47p0.xy,
		n_out48p0, n_out49p0, n_out50p0, n_out51p0) * n_out52p1);
	} COLOR.rgb = n_out46p0; COLOR.a = n_out46p1;
}