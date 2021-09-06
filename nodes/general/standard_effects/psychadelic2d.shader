// Edited by Obrymec.
shader_type canvas_item; uniform sampler2D noise;
// This function is called on any draw.
void fragment () {
	// Generate a psychadelic.
	float n_out9p0 = TIME; float n_in10p1 = 0.50000; float n_out10p0 = (n_out9p0 * n_in10p1);
	vec3 n_out6p0 = vec3 (UV, 0.0); vec3 n_out5p0;
	float n_out5p1; {
		vec4 n_tex_read = texture (noise, n_out6p0.xy); n_out5p0 = n_tex_read.rgb; n_out5p1 = n_tex_read.a;
	} float n_out15p0 = n_out5p0.x; float n_out15p1 = n_out5p0.y;
	float n_out15p2 = n_out5p0.z; float n_in17p1 = 0.50000;
	float n_out17p0 = (n_out15p0 - n_in17p1); float n_in12p1 = 0.75000;
	float n_out16p0 = (n_out10p0 + n_out17p0); float n_in12p2 = 0.75000;
	vec3 n_out12p0 = vec3 (n_out16p0, n_in12p1, n_in12p2); vec3 n_out8p0; {
		vec3 c = n_out12p0; vec4 K = vec4 (1.0, (2.0 / 3.0), (1.0 / 3.0),
		3.0); vec3 p = abs (fract (c.xxx + K.xyz) * 6.0 - K.www);
		n_out8p0 = (c.z * mix (K.xxx, clamp (p - K.xxx, 0.0, 1.0), c.y));
	} COLOR.rgb = n_out8p0;
}