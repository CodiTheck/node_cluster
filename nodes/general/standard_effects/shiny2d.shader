// Edited by Obrymec.
shader_type canvas_item; render_mode blend_mix, unshaded;
// Attributes.
uniform vec4 color: hint_color = vec4 (1.0, 1.0, 1.0, 1.0); uniform float strength: hint_range (0, 1) = 0.5;
uniform float offset: hint_range (-0.7, 0.7) = 0; uniform float rotation: hint_range (-90, 90) = 12;
uniform float width: hint_range (0, 0.5) = 0.2; uniform float softness: hint_range (0, 1) = 0.8;
// This method is called on any draw.
void fragment () {
	// Genrate shiny effect.
	float a, b, c, powsum, rad = radians (rotation);
	if (rotation < 45f && rotation > -45f) {
		a = 1.0; b = tan (rad); c = (-0.5f - 0.5f * b - offset / cos (rad));
	} else {
		b = 1.0; a = (1.0 / tan (rad)); c = (-0.5 - 0.5f * a - offset / sin (rad));
	} float d = (abs (a * UV.x + b * UV.y + c) / sqrt (a * a + b * b));
	float edge = ((1.0 - softness) * width);
	if ( d < edge) {
		vec4 colour = texture (TEXTURE, UV); COLOR = (color * strength + colour); COLOR.a = colour.a;
	} else if (d > width) COLOR = texture (TEXTURE, UV);
	else {
		vec4 colour = texture (TEXTURE, UV);
		COLOR = ((width - d) / (width - edge) * color * strength + colour); COLOR.a = colour.a;
	} 
}