shader_type spatial;

uniform sampler2D albedo;
uniform sampler2D heightmap;
uniform float heightRatio = 1.0;


void vertex() {
	VERTEX.y += texture(heightmap, UV).r * heightRatio;
}

void fragment() {
	ALBEDO = texture(albedo, UV).rgb;
}