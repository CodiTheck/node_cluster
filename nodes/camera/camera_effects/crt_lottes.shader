// Edited by Timothy Lottes.
shader_type canvas_item; render_mode blend_mix;
// Attributes.
uniform float hard_scan: hint_range (-20.0, 0.0, 1.0) = -8.0;
uniform float hard_pix: hint_range (-20.0, 0.0, 1.0) = -3.0;
uniform float warpx: hint_range (0.0, 0.125, 0.01) = 0.03;
uniform float warpy: hint_range (0.0, 0.125, 0.01) = 0.04;
uniform float mask_dark: hint_range (0.0, 2.0, 0.1) = 0.5;
uniform float mask_light: hint_range (0.0, 2.0, 0.1) = 1.5;
uniform float scale_in_linear_gamma: hint_range (0.0, 1.0, 1.0) = 1.0;
uniform float shadow_mask: hint_range (0.0, 4.0, 1.0) = 3.0;
uniform float bright_boost: hint_range (0.0, 2.0, 0.05) = 1.0;
uniform float hard_bloom_pix: hint_range (-2.0, -0.5, 0.1) = -1.5;
uniform float hard_bloom_scan: hint_range (-4.0, -1.0, 0.1) = -2.0;
uniform float bloom_amount: hint_range (0.0, 1.0, 0.05) = 0.15;
uniform float shape: hint_range (0.0, 10.0, 0.05) = 2.0;
uniform vec2 output_size = vec2 (1024, 600); uniform vec2 texture_size = vec2 (256, 224);
uniform vec2 input_size = vec2 (256, 224); uniform int frame_count = 0;
// Convert an input to linear1.
float ToLinear1 (float c) {
	if (scale_in_linear_gamma == 0.0) return c;
	return (c <= 0.04045) ? (c / 12.92) : pow ((c + 0.055) / 1.055, 2.4);
}
// Convert a vector3 to linear value.
vec3 ToLinear (vec3 c) {
	if (scale_in_linear_gamma == 0.0) return c;
	return vec3 (ToLinear1 (c.r), ToLinear1 (c.g), ToLinear1 (c.b));
}
// Assuming using sRGB typed textures this should not be needed.
float ToSrgb1 (float c) {
	if (scale_in_linear_gamma == 0.0) return c;
	return (c < 0.0031308 ? (c * 12.92) : 1.055 * pow (c, 0.41666) - 0.055);
}
// Convert a vector3 to srgb.
vec3 ToSrgb (vec3 c) {
	if (scale_in_linear_gamma == 0.0) return c; return vec3 (ToSrgb1 (c.r), ToSrgb1 (c.g), ToSrgb1 (c.b));
}
// Nearest emulated sample given floating point position and texel offset.
vec3 Fetch (sampler2D _TEXTURE, vec2 pos, vec2 off) {
	pos = (floor (pos * vec4 (texture_size, 1.0 / texture_size).xy + off) +
	vec2 (0.5, 0.5)) / vec4 (texture_size, 1.0 / texture_size).xy;
	return ToLinear (bright_boost * texture (_TEXTURE,pos.xy).rgb);
}
// Distance in emulated pixels to nearest texel.
vec2 Dist (vec2 pos) {
	pos = (pos * vec4 (texture_size, 1.0 / texture_size).xy); return -((pos - floor (pos)) - vec2 (0.5));
}
// 1D Gaussian.
float Gaus (float pos, float scale) {return exp2 (scale * pow (abs (pos), shape));}
// 3-Tap Gaussian filter along horz line.
vec3 Horz3 (sampler2D _TEXTURE, vec2 pos, float off) {
	vec3 b = Fetch (_TEXTURE, pos, vec2 (-1.0, off)); vec3 c = Fetch (_TEXTURE, pos, vec2 (0.0, off));
	vec3 d = Fetch (_TEXTURE, pos, vec2 (1.0, off)); float dst = Dist (pos).x; float scale = hard_pix;
	// Convert distance to weight.
	float wb = Gaus ((dst - 1.0), scale); float wc = Gaus ((dst + 0.0), scale);
	float wd = Gaus ((dst + 1.0), scale); return ((b * wb + c * wc + d * wd) / (wb + wc + wd));
}
// 5-Tap Gaussian filter along horz line.
vec3 Horz5 (sampler2D _TEXTURE, vec2 pos, float off) {
	vec3 a = Fetch (_TEXTURE, pos, vec2 (-2.0, off)); vec3 b = Fetch (_TEXTURE, pos, vec2 (-1.0, off));
	vec3 c = Fetch (_TEXTURE, pos, vec2 (0.0, off)); vec3 d = Fetch (_TEXTURE, pos, vec2 (1.0, off));
	vec3 e = Fetch (_TEXTURE, pos, vec2 (2.0, off)); float dst = Dist (pos).x; float scale = hard_pix;
	// Convert distance to weight.
	float wa = Gaus ((dst - 2.0), scale); float wb = Gaus ((dst - 1.0), scale);
	float wc = Gaus ((dst + 0.0), scale); float wd = Gaus ((dst + 1.0), scale);
	float we = Gaus ((dst + 2.0), scale);
	// Return filtered sample.
	return ((a * wa + b * wb + c * wc + d * wd + e * we) / (wa + wb + wc + wd + we));
}
// 7-Tap Gaussian filter along horz line.
vec3 Horz7 (sampler2D _TEXTURE, vec2 pos, float off) {
	vec3 a = Fetch (_TEXTURE, pos, vec2 (-3.0, off)); vec3 b = Fetch (_TEXTURE, pos, vec2 (-2.0, off));
	vec3 c = Fetch (_TEXTURE, pos, vec2 (-1.0, off)); vec3 d = Fetch (_TEXTURE, pos, vec2 (0.0, off));
	vec3 e = Fetch (_TEXTURE, pos, vec2 (1.0, off)); vec3 f = Fetch (_TEXTURE, pos, vec2 (2.0, off));
	vec3 g = Fetch (_TEXTURE, pos, vec2 (3.0, off)); float dst = Dist (pos).x; float scale = hard_bloom_pix;
	// Convert distance to weight.
	float wa = Gaus ((dst - 3.0), scale); float wb = Gaus ((dst - 2.0), scale);
	float wc = Gaus ((dst - 1.0), scale); float wd = Gaus ((dst + 0.0), scale);
	float we = Gaus ((dst + 1.0), scale); float wf = Gaus ((dst + 2.0), scale);
	float wg = Gaus ((dst + 3.0), scale);
	// Return filtered sample.
	return ((a * wa + b * wb + c * wc + d * wd + e * we + f * wf + g * wg)
	/ (wa + wb + wc + wd + we + wf + wg));
}
// Return scanline weight.
float Scan (vec2 pos, float off) {float dst = Dist (pos).y; return Gaus ((dst + off), hard_scan);}
// Return scanline weight for bloom.
float BloomScan (vec2 pos, float off) {float dst = Dist (pos).y; return Gaus ((dst + off), hard_bloom_scan);}
// Allow nearest three lines to effect pixel.
vec3 Tri (sampler2D _TEXTURE, vec2 pos) {
	vec3 a = Horz3 (_TEXTURE, pos, -1.0); vec3 b = Horz5 (_TEXTURE, pos, 0.0);
	vec3 c = Horz3 (_TEXTURE, pos, 1.0); float wa = Scan (pos, -1.0);  float wb = Scan (pos, 0.0);
	float wc = Scan (pos, 1.0); return (a * wa + b * wb + c * wc);
}
// Small bloom.
vec3 Bloom (sampler2D _TEXTURE, vec2 pos) {
	vec3 a = Horz5 (_TEXTURE, pos, -2.0); vec3 b = Horz7 (_TEXTURE, pos, -1.0);
	vec3 c = Horz7 (_TEXTURE, pos, 0.0); vec3 d = Horz7 (_TEXTURE, pos, 1.0);
	vec3 e = Horz5 (_TEXTURE, pos, 2.0); float wa = BloomScan (pos, -2.0); float wb = BloomScan (pos, -1.0); 
	float wc = BloomScan (pos, 0.0); float wd = BloomScan (pos, 1.0); float we = BloomScan (pos, 2.0);
	return (a * wa + b * wb + c * wc + d * wd + e * we);
}
// Distortion of scanlines, and end of screen alpha.
vec2 Warp (vec2 pos) {
	pos = (pos * 2.0 - 1.0); pos *= vec2 (1.0 + (pos.y * pos.y) * warpx, 1.0 + (pos.x * pos.x) * warpy);
	return (pos * 0.5 + 0.5);
}
// Shadow mask.
vec3 Mask (vec2 pos) {
	vec3 mask = vec3 (mask_dark, mask_dark, mask_dark);
	// Very compressed TV style shadow mask.
	if (shadow_mask == 1.0) {
		float line = mask_light; float odd = 0.0; if (fract (pos.x * 0.166666666) < 0.5) odd = 1.0;
		if (fract ((pos.y + odd) * 0.5) < 0.5) line = mask_dark; pos.x = fract (pos.x * 0.333333333);
		if (pos.x < 0.333) mask.r = mask_light; else if (pos.x < 0.666) mask.g = mask_light;
		else mask.b = mask_light; mask *= line;  
	}
	// Aperture-grille.
	else if (shadow_mask == 2.0) {
		pos.x = fract (pos.x * 0.333333333); if (pos.x < 0.333) mask.r = mask_light;
		else if (pos.x < 0.666) mask.g = mask_light; else mask.b = mask_light;
	}
	// Stretched VGA style shadow mask (same as prior shaders).
	else if (shadow_mask == 3.0) {
		pos.x += (pos.y * 3.0); pos.x  = fract (pos.x * 0.166666666); if (pos.x < 0.333) mask.r = mask_light;
		else if (pos.x < 0.666) mask.g = mask_light; else mask.b = mask_light;
	}
	// VGA style shadow mask.
	else if (shadow_mask == 4.0) {
		pos.xy  = floor (pos.xy * vec2 (1.0, 0.5));
		pos.x  += (pos.y * 3.0); pos.x = fract (pos.x * 0.166666666); if (pos.x < 0.333) mask.r = mask_light;
		else if (pos.x < 0.666) mask.g = mask_light; else mask.b = mask_light;
	} return mask;
}
// This method is called on any draw.
void fragment () {
	vec2 pos = Warp (UV.xy * (texture_size.xy / input_size.xy)) *
	(input_size.xy / texture_size.xy); vec3 outColor = Tri (TEXTURE, pos);
	outColor.rgb += (Bloom (TEXTURE, pos) * bloom_amount);
	if (shadow_mask > 0.0) outColor.rgb *= Mask (FRAGCOORD.xy * 1.000001); vec2 bordertest = (pos);
	if (bordertest.x > 0.0001 && bordertest.x < 0.9999 && bordertest.y > 0.0001 && bordertest.y < 0.9999)
		outColor.rgb = outColor.rgb; else outColor.rgb = vec3 (0.0);
	COLOR = vec4 (ToSrgb (outColor.rgb), 1.0);
}