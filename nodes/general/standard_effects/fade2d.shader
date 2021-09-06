// Edited by Obrymec.
shader_type canvas_item; uniform sampler2D fade_mask;
// Attributes.
uniform float amount: hint_range (0.0, 1.0) = 0.5; uniform vec4 fade_color: hint_color;
uniform float color_clamp = 0.99; uniform float fade_threshold: hint_range (0.05, 0.01) = 0.05;
uniform float color_hold = 0.1; uniform float color_fade = 0.1;
// This method is called on every draw.
void fragment () {
	// Sample the fade mask and get the greyscale color.
	vec4 mask_color = texture (fade_mask, UV); float intensity = mask_color.r;
	// Adjust the intensity to stay in the range.
	float full_clamp = (color_clamp - color_hold - color_fade); intensity = (intensity * full_clamp);
	// Get the color of the image.
	vec4 texture_color = texture (TEXTURE, UV);
	// Are we within the threshold ?
	if (amount > (intensity + color_hold + color_fade)) texture_color = vec4 (0.0);
	else if (amount > (intensity + color_hold)) {
		// We have held the color and it is time to fade away.
		float fade_amount = ((amount - intensity - color_hold) / color_fade);
		texture_color = mix (texture_color, vec4 (0.0), fade_amount);
	} else if (amount > intensity) texture_color.rgb = fade_color.rgb;
	else if (amount > (intensity - fade_threshold)) {
		// Start fading towards that color.
		float mix_amount = ((amount - intensity) / (fade_threshold));
		texture_color.rgb = mix (texture_color.rgb, fade_color.rgb, mix_amount);
	} COLOR = texture_color;
}