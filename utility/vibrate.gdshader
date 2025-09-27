shader_type canvas_item;

uniform float intensity = 1.0;
uniform float noise_length;
uniform sampler2D noise;

void vertex() {
	vec2 sample_pos = vec2(0, UV.y);
	//float rng = texture(noise, U);
}
