// Edited by Obrymec.
shader_type canvas_item; uniform bool use_color = true;
uniform bool black_dot = true; uniform float aspect_ratio  = 1.5;
uniform float dots = 50; uniform float min = 0.4;
uniform float max = 0.6; uniform bool use_reshade = false;
// This method is called on any draw.
void fragment () {
	// Attributes treatment.
	bool n_out64p0 = use_color; bool n_out62p0 = black_dot;
	vec3 n_out5p0 = vec3 (SCREEN_UV, 0.0); float n_out12p0 = aspect_ratio;
	float n_out11p0 = dots; float n_out16p0 = (n_out12p0 * n_out11p0);
	float n_in10p2 = 0.00000; vec3 n_out10p0 = vec3 (n_out16p0, n_out11p0, n_in10p2);
	vec3 n_out17p0 = (n_out5p0 * n_out10p0); vec3 n_out18p0 = fract (n_out17p0);
	vec3 n_in19p1 = vec3 (0.50000, 0.50000, 0.50000); vec3 n_out3p0;
	float n_out19p0 = distance (n_out18p0, n_in19p1); float n_out3p1;
	vec3 n_out22p0 = vec3 (SCREEN_UV, 0.0); vec3 n_out70p0;
	{
		vec4 _tex_read = textureLod (SCREEN_TEXTURE, n_out22p0.xy, 0.0);
		n_out3p0 = _tex_read.rgb; n_out3p1 = _tex_read.a;
	}
	{
		vec3 c = n_out3p0; float max1 = max (c.r, c.g);
		float max2 = max (max1, c.b); float max3 = max (max1, max2);
		n_out70p0 = vec3 (max3, max3, max3);
	}
	float n_out27p0 = min; float n_out28p0 = max;
	vec3 n_out30p0 = clamp (n_out70p0, vec3 (n_out27p0), vec3 (n_out28p0));
	vec3 n_in60p0 = vec3 (1.00000, 1.00000, 1.00000); vec3 n_out60p0 = (n_in60p0 - n_out30p0);
	bool n_out65p0 = n_out19p0 > dot (n_out60p0, vec3 (0.333333, 0.333333, 0.333333));
	bool n_out20p0 = n_out19p0 < dot (n_out30p0, vec3 (0.333333, 0.333333, 0.333333)); vec3 n_out61p0;
	if (n_out62p0) n_out61p0 = vec3 (n_out65p0 ? 1.0 : 0.0);
	else n_out61p0 = vec3 (n_out20p0 ? 1.0 : 0.0); vec3 n_out39p0;
	bool n_out74p0 = use_reshade; vec3 n_out71p0 = vec3 (SCREEN_UV, 0.0);
	float n_out39p1;
	{
		vec4 _tex_read = textureLod (SCREEN_TEXTURE, n_out71p0.xy, 0.0);
		n_out39p0 = _tex_read.rgb; n_out39p1 = _tex_read.a;
	} vec3 n_out73p0; n_out73p0 = vec3 (0.0, 0.0, 0.0);
	{
		vec3 c; c = n_out39p0;
		if (abs (c.r - c.g) > 0.1 || abs (c.g - c.b) > 0.1 || abs (c.b - c.r) > 0.1) {
			c.rgb = mix (vec3 (0.0), c.rgb, 2); c.rgb = mix (vec3 (0.5), c.rgb, 1);
			c.rgb = mix (vec3 (dot (vec3 (1.0), c.rgb) * 0.33333), c.rgb, 2);
		} else c = vec3 (1.0, 1.0, 1.0); n_out73p0.rgb = c;
	} vec3 n_out75p0; if (n_out74p0) n_out75p0 = n_out73p0; else n_out75p0 = n_out39p0;
	vec3 n_out54p0 = (n_out61p0 * n_out75p0); vec3 n_out63p0;
	if (n_out64p0) n_out63p0 = n_out54p0; else n_out63p0 = n_out61p0; COLOR.rgb = n_out63p0;
}