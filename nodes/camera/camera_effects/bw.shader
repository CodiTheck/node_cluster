// SHADER ORIGINALY CREADED BY "demofox" FROM SHADERTOY
shader_type canvas_item;
// This method is called on any draw.
void fragment () {
	// Generate bw effect.
	vec2 percent = UV; percent.y = (1.0 - percent.y); float mode = 3.0;
	vec3 pixelColor = texture (SCREEN_TEXTURE, percent).xyz;
	if (mode > 3.0) {
		// SRGB monitors grey scale coefficients.
		float pixelGrey = dot (pixelColor, vec3 (0.2126, 0.7152, 0.0722)); pixelColor = vec3 (pixelGrey);
	} else if (mode > 2.0) {
		// SD television grey scale coefficients.
		float pixelGrey = dot (pixelColor, vec3 (0.3, 0.59, 0.11)); pixelColor = vec3 (pixelGrey);
	} else if (mode > 1.0) {
		// Naive grey scale conversion, average R, G and B.
		float pixelGrey = dot (pixelColor, vec3 (1.0 / 3.0)); pixelColor = vec3 (pixelGrey);
	} COLOR = vec4 (pixelColor, 1.0);
}