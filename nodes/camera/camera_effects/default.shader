// Edited by Obrymec.
shader_type canvas_item; uniform float size: hint_range (0, 7) = 3.0;
// Called on any draw.
void fragment () {COLOR.rgb = textureLod (SCREEN_TEXTURE, SCREEN_UV, size).rgb;}