// Edited by Obrymec.
shader_type spatial; render_mode specular_disabled, ambient_light_disabled;
// Attributes.
uniform float rim_size: hint_range (0.0, 1.0) = 0.3; uniform float normal_offset_x = 0.0;
uniform float normal_offset_y = 0.0;
// Generate vertex.
void vertex () {NORMAL += vec3 (normal_offset_x, normal_offset_y, 0);}
// Called on any draw.
void fragment () {ALBEDO = vec3 (0); ROUGHNESS = 0.8; RIM = 1.0; RIM_TINT = (1.0 - rim_size);}