// Edited by Obrymec.
shader_type canvas_item; uniform float vibration = 0.7; uniform float speed = 0.6;
// Return a randomized float value.
float random2d (vec2 n) {return fract (sin (dot (n, vec2 (12.9898, 4.1414))) * 43758.5453);}
// Return a randomized float range value.
float randomRange (in vec2 seed, in float min, in float max) {return (min + random2d (seed) * (max - min));}
// Return 1 whether v is inside of 1d range.
float insideRange (float v, float bottom, float top) {return (step (bottom, v) - step (top, v));}
// This function is called on any draw.
void fragment () {
	// Generate glitch effect.
	float time = floor (TIME * speed * 60.0); vec2 uv = SCREEN_UV;
	// Copy orig.
	vec3 outCol = texture (SCREEN_TEXTURE, uv).rgb;
	// Randomly offset slices horizontally.
	float maxOffset = (vibration / 2.0);
	for (float i = 0.0; i < (10.0 * vibration); i += 1.0) {
		float sliceY = random2d (vec2 (time , 2345.0 + float (i)));
		float sliceH = (random2d (vec2 (time , 9035.0 + float (i))) * 0.25);
		float hOffset = randomRange (vec2 (time , 9625.0 + float (i)), -maxOffset, maxOffset);
		vec2 uvOff = uv; uvOff.x += hOffset;
		if (insideRange (uv.y, sliceY, fract (sliceY + sliceH)) == 1.0) {
			outCol = texture (SCREEN_TEXTURE, uvOff).rgb;
		}
	}
	// Do slight offset on one entire channel.
	float maxColOffset = (vibration / 6.0); float rnd = random2d (vec2 (time , 9545.0));
	vec2 colOffset = vec2 (randomRange (vec2 (time , 9545.0),
	-maxColOffset,maxColOffset), randomRange (vec2 (time , 7205.0), -maxColOffset, maxColOffset));
	if (rnd < 0.33) outCol.r = texture (SCREEN_TEXTURE, (uv + colOffset)).r;
	else if (rnd < 0.66) outCol.g = texture (SCREEN_TEXTURE, (uv + colOffset)).g;
	else outCol.b = texture (SCREEN_TEXTURE, (uv + colOffset)).b; COLOR = vec4 (outCol, 1.0);
}