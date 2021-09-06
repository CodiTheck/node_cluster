// SHADER ORIGINALY CREADED BY "juniorxsound".
shader_type canvas_item; varying float time;
// Apply vertex.
void vertex () {time = TIME;}
// Generate grain.
float grain (vec2 st) {return fract (sin (dot (st.xy, vec2 (17.0, 180.0))) * 2500. + time);}
// This method is called on any draw.
void fragment () {
	// Coords.
	vec2 uv = UV; uv.y = ((uv.y - 1.0) * -1.0);
	// Produce some noise based on the coords.
	vec3 grainPlate = vec3 (grain (uv));
	// Get the image.
	vec4 img = texture (SCREEN_TEXTURE, uv);
	// Mix the two signals together.
	vec3 mixer = mix (img.rgb, grainPlate, 0.1); COLOR = vec4 (mixer, 1.0); 
}