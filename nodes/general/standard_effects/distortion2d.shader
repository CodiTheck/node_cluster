// Edited by Obrymec.
shader_type canvas_item;
// Return distortion UV animated as vec2 format.
vec2 d1stort1onUVAnimatedFunc (vec2 _uv_d1st, float _d1stX_d1st, float _d1stY_d1st,
float _waveX_d1st, float _waveY_d1st, float _spd_d1st, float _t1me_d1st) {
	_uv_d1st.x += (sin (_uv_d1st.y * _waveX_d1st + _t1me_d1st * _spd_d1st) * _d1stX_d1st);
	_uv_d1st.y += (sin (_uv_d1st.x * _waveY_d1st + _t1me_d1st * _spd_d1st) * _d1stY_d1st); return _uv_d1st;
}
// Called on every draw.
void fragment () {
	// Generate distortion effect.
	vec3 n_out3p0 = vec3 (UV, 0.0); float n_out26p0 = 5.000000;
	float n_out30p0 = 5.000000; float n_out27p0 = -0.200000;
	float n_out28p0 = 0.010000; float n_out29p0 = 1.000000;
	float n_out25p0 = TIME; vec3 n_out24p0; {
		n_out24p0.xy = d1stort1onUVAnimatedFunc (n_out3p0.xy, n_out27p0, n_out28p0,
		n_out26p0, n_out30p0, n_out29p0, n_out25p0);
	} vec3 n_out5p0; float n_out5p1; {
		vec4 _tex_read = texture (TEXTURE, n_out24p0.xy); n_out5p0 = _tex_read.rgb; n_out5p1 = _tex_read.a;
	} COLOR.rgb = n_out5p0; COLOR.a = n_out5p1;
}