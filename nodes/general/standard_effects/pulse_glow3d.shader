// Edited by Fernando Cosentino.
shader_type spatial; render_mode blend_add, unshaded;
// Attributes.
uniform vec4 albedo: hint_color = vec4 (1.0, 1.0, 1.0, 1.0); uniform sampler2D albedo_texture: hint_albedo;
uniform float saturation: hint_range (0.5, 1.0) = 1.0; uniform float pulse_rate = 5.0;
uniform float pulse_intensity = 0.1; uniform float opacity: hint_range (0.0, 1.0) = 1.0;
// Generate vertex.
void vertex () {
	// Pulsating angular frequency.
	float pulse_freq = (TIME * pulse_rate * 6.2831853); float pulse_val = (0.5 * (sin (pulse_freq) + 1.0));
	// Sine^4 causes the wave to have strong fast peaks with larger intervals.
	pulse_val = pow (pulse_val, 4); VERTEX += (NORMAL * (pulse_val * pulse_intensity));
}
// Called on any draw.
void fragment () {
	// Color or texture is straight forward.
	vec4 albedo_tex = texture (albedo_texture, UV); ALBEDO = (albedo.rgb * albedo_tex.rgb);
	// How much is this normal aligned to camera.
	float normal_dot = dot (NORMAL, vec3 (0, 0, 1)); normal_dot = max (normal_dot, 0.0);
	// Avoid negative numbers.
	float arc = (asin (normal_dot * saturation) / 0.785398); arc = pow (arc,10);
	// albedo alpha channel and the opacity parameter.
	float alpha_value = (arc * albedo.a * opacity); alpha_value = min (opacity, alpha_value);
	// Finally apply the alpha.
	ALPHA = (alpha_value);
}