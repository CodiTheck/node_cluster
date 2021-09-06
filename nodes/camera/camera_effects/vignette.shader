// Edited by Obrymec.
shader_type canvas_item; uniform sampler2D vignette; uniform float intensity = 3.0;
// This method is called on any draw.
void fragment () {
	// Generate Vignette effect.
	vec3 vignette_color = texture (vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
	COLOR.rgb = textureLod (SCREEN_TEXTURE, SCREEN_UV, ((1.0 -
	vignette_color.r) * intensity)).rgb; COLOR.rgb *= texture (vignette, UV).rgb;
}