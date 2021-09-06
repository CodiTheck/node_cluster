// Edited by Obrymec.
shader_type canvas_item; uniform float intensity: hint_range (0.0, 0.2) = 0.1; uniform vec4 color: hint_color;
// This method is called on any draw.
void fragment () {
	// Sample at this UV.
	vec4 texture_color = texture (TEXTURE, UV); vec2 new_uv = (UV + ((UV - vec2 (0.5)) * intensity));
	// The "outline", sampling the shrunk sprite. If we are too far, just be nothing.
	vec4 scaled_texture_color;
	if ((new_uv.x < 0.0 || new_uv.x > 1.0) || (new_uv.y < 0.0 || new_uv.y > 1.0)) {
		scaled_texture_color = vec4 (0);
	} else scaled_texture_color = texture (TEXTURE, new_uv); vec4 final_color = texture_color;
	// We are in the inline zone.
	if (texture_color.a > scaled_texture_color.a) final_color = color; COLOR = final_color;
}