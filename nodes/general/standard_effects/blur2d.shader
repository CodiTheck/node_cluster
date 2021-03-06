// Edited by Obrymec.
shader_type canvas_item; uniform float radius = 10.0;
// This method is called on any draw.
void fragment () {
	// Generate an advanced blur effect.
	vec4 new_color = texture (TEXTURE, UV); vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	new_color += texture (TEXTURE, UV + vec2 (0, -radius) * pixel_size);
	new_color += texture (TEXTURE, UV + vec2 (0, radius) * pixel_size);
	new_color += texture (TEXTURE, UV + vec2 (-radius, 0) * pixel_size);
	new_color += texture (TEXTURE, UV + vec2 (radius, 0) * pixel_size); COLOR = (new_color / 5.0);
}