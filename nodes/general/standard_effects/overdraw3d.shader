// Edited by Obrymec.
shader_type spatial; render_mode unshaded, blend_add;
// What color to use for the overdraw ?
uniform vec4 color: hint_color = vec4 (0.5, 0.5, 0.5, 1.0);
// Generate vertex color.
void vertex () {COLOR *= color;} void fragment () {ALBEDO = color.rgb;}