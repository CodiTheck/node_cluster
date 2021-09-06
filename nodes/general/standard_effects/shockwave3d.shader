// Edited by Obrymec.
shader_type spatial; render_mode world_vertex_coords, cull_disabled;
// Attributes.
uniform vec3 origin = vec3 (0.0, 5.0, 0.0); uniform float radius = 16.0;
uniform float percentage: hint_range (0.0, 1.5) = 0.0; uniform float width = 0.8;
uniform float strength = 0.5;
// Generate vertex.
void vertex () {
	// Generate shockwave effect.
	vec3 to_origin = (VERTEX.xyz - origin); float max_effective_distance = (percentage * radius);
	float min_effective_distance = max (0, max_effective_distance - width);
	float distance_to_origin = length (to_origin);
	float effective_distance = smoothstep (min_effective_distance,
	(max_effective_distance - width / 2.0), distance_to_origin) *
	(1.0 - smoothstep (max_effective_distance, (max_effective_distance + width / 2.0), distance_to_origin));
	VERTEX += (normalize (to_origin) * effective_distance * strength);
}
// Called on every draw.
void fragment () {ALBEDO = vec3 (0.5, 0.5, 0.75);}