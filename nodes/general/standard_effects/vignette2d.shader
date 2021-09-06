// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform vec4 color: hint_color = vec4 (0, 0, 0, 1); uniform float radius: hint_range (0, 0.7) = 0.4;
uniform float width: hint_range (0.01, 0.2);
// This method is called on any draw.
void fragment () {
	// Generate vignette effect.
	float l = length (UV - vec2 (0.5)); if (l < radius) COLOR = texture (TEXTURE, UV);
	else if (l > (radius + width)) COLOR = color;
	else {float k = ((l - radius) / width); COLOR = mix (texture (TEXTURE, UV), color, k);}
}