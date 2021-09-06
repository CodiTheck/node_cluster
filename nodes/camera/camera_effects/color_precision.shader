// SHADER ORIGINALY CREADED BY "abelcamarena" FROM SHADERTOY.
shader_type canvas_item; uniform float screen_width = 320.0;
uniform float color_factor: hint_range (0.0, 10.0) = 4.0;
// This method is called on any draw.
void fragment () {
	// Reduce pixels.            
	vec2 size = ((screen_width * SCREEN_PIXEL_SIZE.xy) / SCREEN_PIXEL_SIZE.x);
	vec2 coor = floor (UV * size); vec2 uv = (coor / size);   
	uv.y = ((uv.y - 1.0) * -1.0); vec3 col = texture (SCREEN_TEXTURE, uv).xyz;     
	// Reduce colors.  
	col = (floor (col * color_factor) / color_factor); COLOR = vec4 (col, 1.0);
}