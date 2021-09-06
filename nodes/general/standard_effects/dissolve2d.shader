// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform sampler2D noise_texture; uniform float factor: hint_range (0, 1) = 0.5;
uniform vec4 color: hint_color = vec4 (1, 0, 0, 1); uniform float width: hint_range (0.01, 0.5) = 0.1;
// This method is called on every draw.
void fragment () {
	// Generate dissolve effect.
	vec4 c = texture (noise_texture, UV); vec4 cl = texture (TEXTURE, UV);
	if (cl.a < 0.001) discard; if (c.r < (factor - width)) discard;
	else if (c.r < factor) {
		float k = ((factor - c.r) / width); vec4 c2 = vec4 (color.rgb, 1.0); COLOR = (c2 * (1.0 - k));
	} else if (c.r < (factor + width)) {
		float k = ((c.r - factor) / width); vec4 c2 = vec4 (color.rgb, 1.0); COLOR = mix (cl, c2, 1.0 - k);
	} else COLOR = cl;
}