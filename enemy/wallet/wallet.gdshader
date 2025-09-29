shader_type canvas_item;

uniform float period = 1.0;
uniform float bounce = 10.0;

void vertex() {
	float prog = mod(TIME, period)/period*PI*2.0;
	VERTEX = vec2(VERTEX.x*sin(prog), VERTEX.y+cos(prog)*bounce);
}
