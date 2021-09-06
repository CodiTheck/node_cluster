// SHADER ORIGINALY CREADED BY "Wunkolo" FROM SHADERTOY.
shader_type canvas_item; uniform vec3 Shadows = vec3 (0.0, 0.0, 0.0);
uniform vec3 Midtones = vec3 (0.0, 0.0, 0.0); uniform vec3 Hilights = vec3 (0.5, 0.0, 0.0);
// Calculate the invert lerp.
vec3 InvLerp ( vec3 A, vec3 B, vec3 t) {return (t - A) / (B - A);}
// Generate color grade.
vec3 ColorGrade (in vec3 InColor) {
	// Calculate the three offseted colors up-front.
	vec3 OffShadows  = (InColor + Shadows); vec3 OffMidtones = (InColor + Midtones);
	vec3 OffHilights = (InColor + Hilights);
	// Linearly interpolate between the 3 new colors, piece-wise.
	return mix (
		mix (OffShadows, OffMidtones, InvLerp (vec3 (0.0), vec3 (0.5), InColor)),
		mix (OffMidtones, OffHilights, InvLerp (vec3 (0.5), vec3 (1.0), InColor)),
		greaterThanEqual (InColor, vec3 (0.5))
	);
}
// This method is called on any draw.
void fragment () {
	// Generate better cc effect.
	vec2 uv = (FRAGCOORD.xy / vec2 (1.0 / SCREEN_PIXEL_SIZE.xy));
	COLOR.a = 1.0; COLOR.rgb = texture (SCREEN_TEXTURE, uv).rgb; COLOR.rgb = ColorGrade (COLOR.rgb);
}