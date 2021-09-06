// Edited by Obrymec.
shader_type canvas_item;
// This method is called on any draw.
void fragment () {vec3 c = textureLod (SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb; COLOR.rgb = normalize (c);}