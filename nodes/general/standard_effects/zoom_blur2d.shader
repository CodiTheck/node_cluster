// Edited by Obrymec.
shader_type canvas_item;
// Return zoom blur as vec2 format.
vec4 zoomBlurFunc (sampler2D _tex_z00m_blur, vec2 _uv_z00m_blur, int _amount_z00m_blur,
vec2 _center_zoom, float _lgt_z00m_blur, float _lod_z00m_blur) {vec4 _col_z00m_blur;
	if (_lod_z00m_blur < 0.0) {
		_col_z00m_blur = texture (_tex_z00m_blur, _uv_z00m_blur);
		for (int i = 1; i <= _amount_z00m_blur; i++) {
			float _temp_d_z00m_blur = (_lgt_z00m_blur * float (i));
			vec2 px = (_uv_z00m_blur * (1.0 - _temp_d_z00m_blur) + _center_zoom * _temp_d_z00m_blur);
			_col_z00m_blur += texture (_tex_z00m_blur, px);
		}
	} else {
		_col_z00m_blur = textureLod (_tex_z00m_blur, _uv_z00m_blur, _lod_z00m_blur);
		for (int i = 1; i <= _amount_z00m_blur; i++) {
			float _temp_d_z00m_blur = (_lgt_z00m_blur * float (i));
			vec2 px = (_uv_z00m_blur * (1.0 - _temp_d_z00m_blur) + _center_zoom * _temp_d_z00m_blur);
			_col_z00m_blur += textureLod (_tex_z00m_blur, px, _lod_z00m_blur);
		}
	} _col_z00m_blur = (_col_z00m_blur / float (_amount_z00m_blur + 1)); return _col_z00m_blur;
}
// Called on any draw.
void fragment () {
	// Generate zoom blur effect.
	vec3 n_out6p0 = vec3 (UV, 0.0); float n_out13p0 = -1.000000;
	vec3 n_out15p0 = vec3 (0.500000, 0.500000, 0.000000);
	float n_out14p0 = 20.000000; float n_out12p0 = 0.100000;
	float n_in9p0 = 1.00000; float n_out9p0; {n_out9p0 = (n_out12p0 * sin (n_in9p0 * TIME));}
	vec3 n_out11p0; float n_out11p1; {
		vec4 n_out11p0n_out11p1 = zoomBlurFunc (TEXTURE, n_out6p0.xy,
		int (n_out14p0), n_out15p0.xy, n_out9p0, n_out13p0);
		n_out11p0 = n_out11p0n_out11p1.rgb; n_out11p1 = n_out11p0n_out11p1.a;
	} COLOR.rgb = n_out11p0; COLOR.a = n_out11p1;
}