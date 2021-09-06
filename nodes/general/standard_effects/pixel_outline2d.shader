// Edited by Obrymec.
shader_type canvas_item;
// Attributes.
uniform float intensity: hint_range (0.0, 0.09) = 0.03; uniform vec4 color: hint_color;
// Generate color vertex.
void vertex () {VERTEX *= (1.0 + intensity);}
// This method is called onevery draw.
void fragment () {
	// Get where this would be on the regular image.
	vec2 regular_uv = (UV + ((UV - vec2 (0.5)) * intensity));
	// Is this outside the original sprite ?
	vec4 regular_color = texture (TEXTURE, regular_uv);
	if ((regular_uv.x < 0.0 || regular_uv.x > 1.0) || (regular_uv.y < 0.0 ||
	regular_uv.y > 1.0)) {regular_color = vec4 (0);}
	// Now we need to sample pixels on either side of this one, depending on the intensity.
	vec4 final_color = regular_color;
	for (int x = -1; x <= 1; x += 2) {
		for (int y = -1; y <= 1; y += 2) {
			// Get the X and Y offset from this.
			vec2 outline_uv = regular_uv + vec2 (float (x) * intensity, float (y) * intensity);
			// Sample here, if we are out of bounds then fail.
			vec4 outline_sample = texture (TEXTURE, outline_uv);
			if ((outline_uv.x < 0.0 || outline_uv.x > 1.0) || (outline_uv.y < 0.0
			|| outline_uv.y > 1.0)) {outline_sample = vec4 (0);}
			// Is our sample empty ? Is there something nearby ?
			if (outline_sample.a > final_color.a) final_color = color;
		}
	} COLOR = final_color;
}