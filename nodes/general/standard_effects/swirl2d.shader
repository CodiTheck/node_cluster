// Edited by Obrymec.
shader_type canvas_item;
// Return Swirl UV as vec2 format.
vec2 swirlUVFunc (vec2 _uv_sw1rl, float _t1me_sw1rl, vec2 _p1vot_sw1rl, float _amount_sw1rl) {
	float _rotation_index_sw1rl = (_amount_sw1rl * length (_uv_sw1rl - _p1vot_sw1rl)
	* _t1me_sw1rl); _uv_sw1rl -= _p1vot_sw1rl;
	_uv_sw1rl *= mat2 (vec2 (cos (_rotation_index_sw1rl), - sin (_rotation_index_sw1rl)),
	vec2 (sin (_rotation_index_sw1rl), cos (_rotation_index_sw1rl)));
	_uv_sw1rl += _p1vot_sw1rl; return _uv_sw1rl;
}
// Called onany draw.
void fragment () {
	// Generate swirl effect.
	vec3 n_out3p0 = vec3 (UV, 0.0); vec3 n_out13p0 = vec3 (0.500000, 0.500000, 0.000000);
	float n_out10p0 = 1.000000; float n_out12p0 = 10.000000;
	float n_in11p0 = 1.00000; float n_out11p0; {n_out11p0 = (n_out12p0 * sin (n_in11p0 * TIME));}
	vec3 n_out9p0; {n_out9p0.xy = swirlUVFunc (n_out3p0.xy, n_out11p0, n_out13p0.xy, n_out10p0);}
	vec3 n_out5p0; float n_out5p1; {
		vec4 _tex_read = texture (TEXTURE, n_out9p0.xy); n_out5p0 = _tex_read.rgb; n_out5p1 = _tex_read.a;
	} COLOR.rgb = n_out5p0; COLOR.a = n_out5p1;
}