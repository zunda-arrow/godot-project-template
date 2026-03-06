shader_type canvas_item;

uniform float intensity = 0.0;
const vec4 WHITE = vec4(1., 1., 1., 1.);

void fragment(){
	COLOR = mix(COLOR, WHITE, intensity);
}
