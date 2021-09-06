/*Fire Shader by Yui Kinomoto @arlez80*/
shader_type spatial; render_mode depth_draw_opaque, unshaded, shadows_disabled;
// Attributes.
uniform sampler2D noise_tex: hint_white; uniform vec4 root_color: hint_color = vec4 (1.0, 0.75, 0.3, 1.0);
uniform vec4 tip_color: hint_color = vec4 (1.0, 0.03, 0.001, 1.0);
uniform float fire_alpha: hint_range (0.0, 1.0) = 1.0; uniform float fire_speed = 1.0;
uniform float fire_aperture: hint_range (0.0, 3.0) = 0.22;
// Called on any draw.
void fragment () {
	// Generate 3d fire effect.
	vec2 shifted_uv = (UV + vec2 (0.0, (TIME * fire_speed)));
	float fire_noise = texture (noise_tex, shifted_uv).r;
	float noise = (UV.y * (((UV.y + fire_aperture) * fire_noise - fire_aperture) * 75.0));
	vec4 fire_color = mix (tip_color, root_color, (noise * 0.05));
	ALPHA = (clamp (noise, 0.0, 1.0) * fire_alpha); ALBEDO = fire_color.rgb;
}