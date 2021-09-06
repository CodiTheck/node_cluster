// Edited by Obrymec.
shader_type canvas_item;
// Attributes.
uniform float intensity: hint_range (0.0, 0.1) = 0.05; uniform vec4 outline_color: hint_color;
// Generate color vertex.
void vertex () {VERTEX *= (1.0 + intensity);}
// This function is called on any draw.
void fragment () {
	// Get where this would be on the regular image.
	vec2 new_uv = (UV + ((UV - vec2 (0.5)) * intensity)); vec4 texture_color;
	// We aren't a real color.
	if ((new_uv.x < 0.0 || new_uv.x > 1.0) || (new_uv.y < 0.0 || new_uv.y > 1.0)) texture_color = vec4 (0);
	// The "outline", sampling the exploded sprite.
	else texture_color = texture (TEXTURE, new_uv); vec4 scaled_texture_color = texture (TEXTURE, UV);
	// Is there more "outline" color than "original" color ?
	vec4 final_color; if (scaled_texture_color.a > texture_color.a) final_color = outline_color;
	else final_color = texture_color; COLOR = final_color;
}