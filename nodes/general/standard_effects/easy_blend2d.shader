// Edited by Obrymec.
shader_type canvas_item; uniform sampler2D blend; uniform float intensity: hint_range (0, 1) = 1.0;
// Called on any draw
void fragment () {
	// Generate an easy blend effect.
	vec4 bgColor; vec4 Color = texture (TEXTURE, UV); vec4 blendColor; vec4 output = vec4 (1, 1, 1, 1);
	bgColor = texture (SCREEN_TEXTURE, SCREEN_UV); output.a = Color.a;
	blendColor = texture (blend, vec2 (bgColor.r, Color.r)); output.r = blendColor.r;
	blendColor = texture (blend, vec2 (bgColor.g, Color.g)); output.g = blendColor.g;
	blendColor = texture (blend, vec2 (bgColor.b, Color.b)); output.b = blendColor.b;
	output.rgb = mix (Color.rgb, output.rgb, intensity); COLOR = output;
}