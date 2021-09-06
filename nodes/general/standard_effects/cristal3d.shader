// Edited by Obrymec.
shader_type spatial;
// Attributes.
uniform sampler2D texture_albedo: hint_albedo; uniform float metallic: hint_range (0.0, 1.0) = 0.5;
uniform float roughness: hint_range (0.0, 1.0) = 0.0; uniform sampler2D texture_emission: hint_black_albedo;
uniform vec4 emission: hint_color = vec4 (0.0, 1.0, 0.0, 1.0);
uniform float emission_energy = 10.0; uniform sampler2D texture_normal: hint_normal;
uniform float fresnel_power = 10.0; uniform float fresnel_color_intensity = 5.0;
uniform vec4 fresnel_color: hint_color = vec4 (0.0, 0.0, 1.0, 1.0);
uniform float fresnel_pulse_speed = 3.0; uniform float emission_pulse_speed = 3.0;
// Called on every draw.
void fragment () {
	// Generate cristal effect.
	ALBEDO = texture (texture_albedo, UV).rgb; METALLIC = metallic;
	ROUGHNESS = roughness; NORMALMAP = texture (texture_normal, UV).rgb;
	vec3 emission_tex = texture (texture_emission, UV).rgb;
	float fresnel = pow (1.0 - dot (NORMAL, VIEW), fresnel_power);
	float fresnel_time_factor = clamp (sin (TIME * fresnel_pulse_speed),
	0.15, 1); float emission_time_factor = clamp (sin (TIME * emission_pulse_speed)
	+ 0.33, 0.33, 1); EMISSION = ((emission.rgb*emission_tex) * emission_energy *
	emission_time_factor) + (fresnel * fresnel_color.rgb * fresnel_color_intensity * fresnel_time_factor);
}