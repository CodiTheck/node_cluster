// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform vec4 color: hint_color = vec4 (0, 0, 0, 1.0); uniform float factor: hint_range (0, 1) = 0.5;
// This method is called on any draw.
void fragment () {vec4 c = texture (TEXTURE, UV); vec4 c2 = (c * color); COLOR = mix (c, c2, factor);}