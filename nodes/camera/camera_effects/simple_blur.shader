// Edited by Obrymec.
shader_type canvas_item; uniform float amount: hint_range (0.0, 5.0) = 1.0;
// This method is called on any draw.
void fragment () {COLOR.rgb = textureLod (SCREEN_TEXTURE, SCREEN_UV, amount).rgb;}