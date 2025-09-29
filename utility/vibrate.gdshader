shader_type canvas_item;

uniform float intensity = 1.0;
uniform float period = 1.0;
uniform sampler2D noise1;
uniform sampler2D noise2;

void vertex() {
	float prog = mod(TIME, period)/period;
	vec2 sample_pos = vec2((UV.x+prog)/2.0, UV.y);
	float rng_ang = texture(noise1, sample_pos).x*PI*2.0;
	float rng_mag = texture(noise2, sample_pos).x;
	VERTEX += vec2(cos(rng_ang), sin(rng_ang))*rng_mag*intensity;
}
