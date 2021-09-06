// Edited by Obrymec.
shader_type spatial; render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;
// Attributes.
uniform vec4 albedo: hint_color; uniform sampler2D texture_albedo: hint_albedo;
uniform float specular = 1.0; uniform float metallic: hint_range (0.0, 1.0) = 0.0;
uniform float roughness: hint_range (0.0, 1.0) = 1.0; uniform sampler2D texture_roughness: hint_white;
uniform vec4 roughness_texture_channel; uniform sampler2D texture_emission: hint_black_albedo;
uniform float emission_energy = 0.0; uniform float debanding_dither = 0.0;
const vec3 noise_magic = vec3 (0.06711056, 0.00583715, 52.9829189);
// Generate vertex.
void vertex () {UV = UV;}
// Called on every draw.
void fragment () {
	// Generate debanding material effect.
	vec2 base_uv = UV; vec4 albedo_tex = texture (texture_albedo, base_uv); albedo_tex *= COLOR;
	// Add noise to albedo to hide banding in GLES2.
	if (OUTPUT_IS_SRGB) {
		float offset = fract (noise_magic.z * fract (dot (FRAGCOORD.xy, noise_magic.xy)));
		albedo_tex.rgb += (vec3 (offset, (1.0 - offset), offset) * debanding_dither);
	} ALBEDO = (albedo.rgb * albedo_tex.rgb); METALLIC = metallic;
	float roughness_tex = dot (texture (texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = (roughness_tex * roughness); SPECULAR = specular;
	vec3 emission_tex = texture (texture_emission, base_uv).rgb; EMISSION = (emission_tex * emission_energy);
}