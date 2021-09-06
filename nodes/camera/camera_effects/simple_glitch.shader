// Edited by Obrymec.
shader_type canvas_item;
// This method is called on any draw.
void fragment () {
	// Generate a basic glitch effect.
	vec2 screen_uv = SCREEN_UV; vec2 uv = UV; float glitchPrs1 = sin (uv.y - TIME * 0.6); 
	float glitchPrs2 = sin (uv.y - TIME * 2.0); 
	if (glitchPrs2 >= 0.1 && glitchPrs2 <= 0.4) {
		if (glitchPrs1 >= -0.1 && glitchPrs1 <= 0.2) screen_uv.x += 0.02;
		else if (glitchPrs1 > 0.3 && glitchPrs1 <= 0.7) screen_uv.x += -0.02;
		else if (glitchPrs1 > 0.70 && glitchPrs1 < 1.0) screen_uv.x += 0.03;
		else if (glitchPrs1 < 0.0 && glitchPrs1 >= -0.4) screen_uv.x -= 0.01;
	} if (glitchPrs2 > 0.4 && glitchPrs2 <= 0.9) {
		if (uv.y >= 0.7) screen_uv.x += -0.02;
		else if (uv.y <= 0.4) screen_uv.x += -0.01; else screen_uv.y += 0.01;
	} if (glitchPrs2 <= -0.5 && glitchPrs2 >= -0.8) {
		if (glitchPrs1 >= 0.0 && glitchPrs1 <= 0.2) screen_uv.x += 0.02;
		else if (glitchPrs1 > 0.2 && glitchPrs1 <= 0.5) screen_uv.x += +0.02;
		else if (glitchPrs1 > 0.50 && glitchPrs1 < 0.7) screen_uv.x += 0.01;
		else if (glitchPrs1 <= -0.4 && glitchPrs1 >= -0.7) screen_uv.x -= 0.03;
	} vec4 c = textureLod (SCREEN_TEXTURE, screen_uv, 0.0).rgba; COLOR.rgba = c;
}