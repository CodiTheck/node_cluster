// Edited and updated by Krankomat, Aug 17, 2019.
shader_type canvas_item;
// Colors that we will use.
uniform vec4 color_1: hint_color = vec4 (0.784313725, 0.788235294, 0.262745098,1);
uniform vec4 color_2: hint_color = vec4 (0.490196078, 0.521568627, 0.152941176, 1);
uniform vec4 color_3: hint_color = vec4 (0, 0.415686275, 0, 1);
uniform vec4 color_4: hint_color = vec4 (0.015686275, 0.243137255, 0, 1);
// Color offset - changes threshold for color adjustments.
uniform float offset = 0.5;
// Function to convert a pixel color into grayscale.
vec4 to_grayscale (vec4 pixcol) {
	float average = ((pixcol.r + pixcol.g + pixcol.b) / 3.0); return vec4 (average, average, average, 1);
}
// Colorizes the grayscale pixel.
vec4 colorize (vec4 grayscale) {
	// Color greater than (default) 0.75 in value.
	if (grayscale.r > offset * 1.5) return vec4 (color_1);
	// Color greater than (default) 0.50 in value.
	if (grayscale.r > offset) return vec4 (color_2);
	// Color greater than (default) 0.25 in value.
	if (grayscale.r > offset * 0.5) return vec4 (color_3);
	// Color greater than 0 in value.
	return vec4 (color_4);
}
// This method is called on any draw.
void fragment () {
	// Get pixel color on screen. 
	vec4 pixel_color =  vec4 (texture (SCREEN_TEXTURE, SCREEN_UV));
	// Set the pixel color we are going to use.
	COLOR = colorize (to_grayscale (pixel_color));
}