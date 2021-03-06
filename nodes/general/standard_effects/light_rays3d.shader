// Edited by Obrymec
shader_type spatial; render_mode unshaded, cull_disabled, skip_vertex_transform, blend_add;
// Attributes.
uniform vec4 light_color: hint_color = vec4 (1.0, 1.0, 1.0, 1.0); uniform vec3 light_position = vec3 (0.0, 0.0, 0.0);
uniform float size = 2.0; uniform int light_type: hint_range (0, 1) = 1;
uniform float exposure: hint_range (0.0, 2.0) = 1.0; uniform float attenuate = 1.0;
uniform sampler2D clouds: hint_albedo; uniform bool use_clouds = false; uniform int num_samples = 50;
uniform float dither = 1.0; uniform bool use_pcf5 = true; const float PI = 3.141592653;
const float HALF_PI = (PI / 2.0); varying mat4 inv_project_mat; varying vec4 light_screen_pos;
varying vec3 camera_pos; varying float far_plane; varying float attenuate_size;
// Create a vertex.
void vertex () {
	light_screen_pos = (INV_CAMERA_MATRIX * vec4 (light_position, float (light_type)));
	attenuate_size = (1.0 / length (light_screen_pos) * size);
	light_screen_pos = (PROJECTION_MATRIX * light_screen_pos); light_screen_pos.xyz /= light_screen_pos.w;
	light_screen_pos.xy = (light_screen_pos.xy * 0.5 + 0.5);
	light_screen_pos.z = -(INV_CAMERA_MATRIX * vec4 (light_position, float (light_type))).z;
	camera_pos = CAMERA_MATRIX [3].xyz; inv_project_mat = INV_PROJECTION_MATRIX;
	vec4 _far_plane = (INV_PROJECTION_MATRIX * vec4 (0, 0, 1, 1));
	far_plane = (-_far_plane.z / _far_plane.w); POSITION = vec4 (VERTEX.xy, -1.0, 1.0);
}
// Convert a uv into ray.
vec3 uv_to_ray (vec2 uv, mat4 inv_cam_matrix) {
	vec4 view_space_ray = inv_project_mat * vec4 ((uv * 2.0 - 1.0), 0, 1); view_space_ray.xyz /= view_space_ray.w;
	view_space_ray.w = 0.0; view_space_ray = normalize (view_space_ray); return (view_space_ray * inv_cam_matrix).xyz;
}
// Generate the texture depth.
float depth_texture (sampler2D tex, vec2 uv) {
	float depth = clamp (uv, 0.0, 1.0) == uv ? texture (tex, uv).r : 1.0;
	vec4 upos = (inv_project_mat * vec4 ((uv * 2.0 - 1.0), (depth * 2.0 - 1.0), 1.0)); return (-upos.z / upos.w);
}
// Generate the texture panorama.
vec4 texture_panorama (sampler2D tex, vec3 ray) {
	float u = (atan (ray.x, ray.z) / (2.0 * PI) + 0.5); float v = (asin (ray.y) / PI + 0.5);
	return texture (tex, vec2 (u, (1.0 - v)));
}
// Create the sun light.
float sun_light (sampler2D depth, vec3 ray_o, vec3 ray_d, vec2 uv, vec2 tex_Size) {
	float light_depth = mix (light_screen_pos.z, far_plane, float (1 - light_type));
	float is_obstacle = float (depth_texture (depth, uv) < light_depth);
	if (use_pcf5) {
		is_obstacle += float (depth_texture (depth, uv + tex_Size * vec2 (-1,0)) < light_depth);
		is_obstacle += float (depth_texture (depth, uv + tex_Size * vec2 (1,0)) < light_depth);
		is_obstacle += float (depth_texture (depth, uv + tex_Size * vec2 (0,1)) < light_depth);
		is_obstacle += float (depth_texture (depth, uv + tex_Size * vec2 (0,-1)) < light_depth);
		is_obstacle /= 5.0;
	} if (use_clouds) {
		float temp = texture_panorama (clouds, ray_d).a; if (temp < 0.7) temp = 0.0;
		is_obstacle = min ((is_obstacle + temp), 1.0);
	} float sun = 0.0;
	if (light_type == 0) sun = smoothstep (1.0, 0.0, acos (dot (light_position, ray_d)) / HALF_PI / size);
	else if (light_type == 1) sun = smoothstep (1.0, 0.0, acos (dot (normalize (light_position - ray_o), ray_d))
	/ HALF_PI / attenuate_size); sun *= (1.0 - is_obstacle); return max (sun, 0.0);
}
// Return the smooth step variation.
float variable_smoothstep (float x, float N) {
	if (N > 0.0) return pow (x, N);
	else if (N < 0.0) {
		if (x <= 0.5) return (pow ((2.0 * x), -N) / 2.0); else return (1.0 - pow ((2.0 * (1.0 - x)), -N) / 2.0);
	} return 0.0;
}
// Hash a value.
uint hash (uint x) {
	x = (((x >> uint (16)) ^ x) * uint (73244475)); x = (((x >> uint(16)) ^ x) * uint (73244475));
	x = ((x >> uint (16)) ^ x); return x;
}
// Make a random.
float rand_from_seed (inout uint seed) {
	int k; int s = int (seed); if (s == 0) s = 305420679; k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k; if (s < 0) s += 2147483647; seed = uint (s);
	return (float (seed % uint (65536)) / 65535.0);
}
// Called on any draw.
void fragment () {
	// Generate light ray effect.
	if (length (light_color) <= 0.001) discard; vec2 pixel_size = (1.0 / vec2 (textureSize (SCREEN_TEXTURE, 0)));
	vec2 screen_uv = SCREEN_UV; vec2 delta_uv = ((light_screen_pos.xy - screen_uv) / (float (num_samples)));
	float light = 0.0; uint seed = hash (uint (FRAGCOORD.x + FRAGCOORD.y * float (textureSize (SCREEN_TEXTURE, 0).x)));
	screen_uv += (delta_uv * dither * rand_from_seed (seed));
	for (int i = 0; i < num_samples; i++) {
		vec3 ray = uv_to_ray (screen_uv, INV_CAMERA_MATRIX);
		float sample = sun_light (DEPTH_TEXTURE, camera_pos, ray, screen_uv, pixel_size);
		light += sample; screen_uv += delta_uv;
	} vec3 light_dir = light_type == 0 ? light_position : normalize (light_position - camera_pos);
	float facing_weight = dot (uv_to_ray (vec2 (0.5), INV_CAMERA_MATRIX), light_dir);
	ALBEDO = variable_smoothstep (light / float (num_samples), attenuate) * exposure * light_color.rgb
	* max (facing_weight * facing_weight, 0.0);
}