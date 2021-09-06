// Edited by Obrymec.
shader_type spatial;
// Attributes.
uniform vec4 tint: hint_color = vec4 (1.0, 1.0, 1.0, 1.0);
uniform float specular = 0.9; uniform float strength = 1.0;
uniform sampler2D normal_map; uniform bool use_map = false;
uniform float roughness: hint_range (0.0, 1.0) = 0.4; uniform float metallic: hint_range (0.0, 1.0) = 0.5;
// Called on every draw.
void fragment () {
	// Generate refraction material effect.
	vec2 offset = SCREEN_UV; float xNorm = NORMAL.x;
	float yNorm = NORMAL.y; offset.x += (NORMAL.z * xNorm * strength * 0.01);
	offset.y += (NORMAL.z * yNorm * strength * -0.01);
	ALBEDO = (((texture (SCREEN_TEXTURE, offset).xyz * (1.0 - tint.a)) + (tint.xyz * tint.a)) / 2.0);
	SPECULAR = specular; ROUGHNESS = roughness;
	METALLIC = metallic; if (use_map) NORMALMAP = texture (normal_map, UV).xyz;
}