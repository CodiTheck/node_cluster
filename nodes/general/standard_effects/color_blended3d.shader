// SHADER GRABED FROM THE BOOK OF SHADERS.
shader_type spatial; render_mode cull_disabled, specular_disabled, diffuse_lambert;
// This function is called on any draw.
void fragment () {vec2 st = UV; vec3 final = vec3 (st.x, st.y, 0.0); ALBEDO = final;}